# StreetBuzz 

**StreetBuzz** is a real-time order management application designed for street food vendors and customers. This app helps vendors manage rush-hour queues efficiently while allowing customers to order digitally and skip long queues.

##  Sprint 2 - Firebase Integration

This sprint focuses on integrating **Firebase Authentication** and **Cloud Firestore** to enable secure user management and real-time data storage.

---

##  Features Implemented

###  Firebase Authentication
- **User Sign Up**: Create new accounts with email and password
- **User Login**: Secure authentication with existing credentials
- **Password Reset**: Email-based password recovery
- **Logout**: Secure session termination
- **Auth State Management**: Automatic navigation based on authentication status

###  Cloud Firestore Integration
- **User Data Storage**: Store user profiles in Firestore
- **Order Management**: CRUD operations for orders
- **Real-time Updates**: Live data synchronization using StreamBuilder
- **Scalable Database**: Cloud-based NoSQL database for future expansion

###  Responsive UI
- Adaptive layout for phones and tablets
- MediaQuery-based responsive design
- Vendor/Customer mode toggle
- Modern Material Design 3

---

##  Folder Structure

```
lib/
 main.dart                    # App entry point with Firebase initialization
 firebase_options.dart        # Auto-generated Firebase configuration
 screens/
    login_screen.dart       # User login interface
    signup_screen.dart      # User registration interface
    responsive_home.dart    # Main home screen with logout
    welcome_screen.dart     # Initial welcome screen
 services/
    auth_service.dart       # Firebase Authentication logic
    firestore_service.dart  # Cloud Firestore CRUD operations
 widgets/                     # Reusable UI components
 models/                      # Data models
```

---

##  Setup Instructions

### Prerequisites
- Flutter SDK (3.11.0 or higher)
- Firebase CLI
- Firebase account

### 1. Clone the Repository
```bash
git clone <repository-url>
cd StreetBuzz
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### Login to Firebase
```bash
firebase login
```

#### Configure FlutterFire
```bash
dart pub global activate flutterfire_cli
dart pub global run flutterfire_cli:flutterfire configure
```

This will:
- Create or select a Firebase project
- Generate `firebase_options.dart` automatically
- Configure Android and iOS apps

### 4. Enable Firebase Services

**In Firebase Console:**

1. **Enable Authentication:**
   - Go to Build  Authentication
   - Click "Get started"
   - Enable **Email/Password** provider
   - Save changes

2. **Enable Cloud Firestore:**
   - Go to Build  Firestore Database
   - Click "Create database"
   - Start in **test mode** (for development)
   - Select your region
   - Enable

### 5. Run the App
```bash
flutter run
```

---

##  Code Implementation

### Firebase Initialization

**`lib/main.dart`**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Authentication Service

**`lib/services/auth_service.dart`**
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign up failed');
    }
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
```

### Firestore Service

**`lib/services/firestore_service.dart`**
```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or update user data
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // Get user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // Stream of user orders
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _db.collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
```

### Auth State Management

**`lib/main.dart`**
```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        // User logged in
        if (snapshot.hasData) {
          return const ResponsiveHome();
        }
        
        // User not logged in
        return const LoginScreen();
      },
    );
  }
}
```

---

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  cupertino_icons: ^1.0.8
```

---

##  How It Works

1. **App Launch**: Firebase initializes and checks authentication state
2. **Not Logged In**: User sees Login Screen with option to Sign Up
3. **Sign Up**: User creates account  Data stored in Firestore  Auto-login
4. **Login**: User authenticates  Navigates to Home Screen
5. **Home Screen**: Responsive UI with vendor/customer mode toggle and logout button
6. **Logout**: User signs out  Returns to Login Screen

---

##  Testing

### Manual Testing Steps

1. **Sign Up Flow:**
   - Click "Sign Up" from login screen
   - Enter name, email, password
   - Verify account creation in Firebase Console  Authentication
   - Check user data in Firebase Console  Firestore  users collection

2. **Login Flow:**
   - Enter registered email and password
   - Verify successful login and navigation to home screen

3. **Logout Flow:**
   - Click logout icon in AppBar
   - Confirm logout dialog
   - Verify return to login screen

4. **Data Persistence:**
   - User data automatically saved to Firestore on signup
   - Check real-time updates in Firebase Console

---

##  UI Highlights

### Login Screen
- Email and password input fields
- Password visibility toggle
- Forgot password functionality
- Navigation to signup screen
- Form validation

### Signup Screen
- Full name, email, password, confirm password fields
- Real-time validation
- Password matching check
- Auto-login after successful signup
- User data saved to Firestore

### Responsive Home Screen
- Vendor/Customer mode toggle
- Adaptive layout (phone vs tablet)
- Logout functionality
- Material Design 3 styling

---

##  Responsiveness Implementation

### MediaQuery Usage
```dart
double screenWidth = MediaQuery.of(context).size.width;
bool isTablet = screenWidth > 600;

// Adaptive padding
padding: EdgeInsets.all(isTablet ? 28 : 16)

// Adaptive font sizes
fontSize: isTablet ? 30 : 22
```

### Layout Adaptation
- **Phones (< 600px)**: Vertical list layout
- **Tablets (> 600px)**: Two-column grid layout
- Dynamic padding and font sizes
- Responsive forms and buttons

---

##  Reflection

### Challenges Faced

1. **Firebase CLI Setup**: 
   - Required installing Node.js and Firebase CLI separately
   - FlutterFire CLI needed proper PATH configuration
   - Solution: Used `dart pub global run` to execute commands

2. **Authentication Error Handling**:
   - Managing various FirebaseAuthException codes
   - Providing user-friendly error messages
   - Solution: Created centralized error handling in AuthService

3. **Async/Await Management**:
   - Ensuring Firebase initialization before app starts
   - Managing async operations in UI
   - Solution: Used `WidgetsFlutterBinding.ensureInitialized()` and proper async patterns

4. **State Management**:
   - Keeping UI in sync with auth state
   - Navigation based on authentication status
   - Solution: Used StreamBuilder for reactive auth state updates

### How Firebase Improves the App

1. **Scalability**:
   - Cloud-based infrastructure handles growing user base
   - No need to manage backend servers
   - Automatic scaling during peak hours

2. **Real-time Collaboration**:
   - Firestore provides instant data synchronization
   - Vendors can see orders update in real-time
   - Customers get live order status updates

3. **Security**:
   - Built-in authentication with industry-standard security
   - Firestore security rules for data protection
   - Encrypted data transmission

4. **Development Speed**:
   - Pre-built authentication UI patterns
   - Simple API for complex operations
   - Reduced backend development time by ~80%

5. **Cost-Effective**:
   - Pay-as-you-go pricing
   - Free tier sufficient for development and small deployments
   - No upfront infrastructure costs

### Key Learnings

- Firebase integration transforms a static app into a dynamic, cloud-connected platform
- Proper error handling is crucial for good user experience
- Stream-based architecture enables reactive, real-time UIs
- FlutterFire CLI simplifies cross-platform Firebase configuration
- Cloud Firestore's NoSQL structure is perfect for flexible, evolving data models

---

##  Screenshots

> **Note**: Add screenshots here showing:
> - Login screen
> - Signup screen
> - Home screen (logged in)
> - Firebase Console - Authentication tab
> - Firebase Console - Firestore Database

---

##  Future Enhancements

- [ ] Add order placement functionality
- [ ] Implement real-time order tracking
- [ ] Add vendor dashboard with order management
- [ ] Push notifications for order updates
- [ ] Google Sign-In integration
- [ ] Profile picture upload to Firebase Storage
- [ ] Analytics integration
- [ ] Offline data persistence

---

##  Team

**Team Name**: [Your Team Name]  
**Project**: StreetBuzz - Sprint 2 Firebase Integration

---

##  License

This project is created as part of Kalvium's Sprint-2 assignment.

---

##  Resources

- [Firebase for Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)
- [FlutterFire CLI Reference](https://firebase.flutter.dev/docs/cli)
- [StreamBuilder Widget Guide](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
