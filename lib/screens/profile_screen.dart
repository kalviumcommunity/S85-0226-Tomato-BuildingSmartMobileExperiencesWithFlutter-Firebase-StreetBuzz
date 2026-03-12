import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isEditing = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    try {
      final user = await _firestoreService.getUser(currentUser.uid);
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = user.displayName;
          _emailController.text = user.email;
          _isLoading = false;
        });
      } else {
        // Create user profile if it doesn't exist
        final newUser = UserModel(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          displayName: currentUser.displayName ?? currentUser.email?.split('@')[0] ?? '',
          photoURL: currentUser.photoURL,
          createdAt: currentUser.metadata.creationTime ?? DateTime.now(),
          lastLogin: DateTime.now(),
        );
        await _firestoreService.saveUser(newUser);
        setState(() {
          _user = newUser;
          _nameController.text = newUser.displayName;
          _emailController.text = newUser.email;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading profile: ${e.toString()}');
    }
  }

  Future<void> _updateProfile() async {
    if (_user == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = _user!.copyWith(
        displayName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        lastLogin: DateTime.now(),
      );

      await _firestoreService.updateUser(updatedUser);
      setState(() {
        _user = updatedUser;
        _isEditing = false;
        _isLoading = false;
      });
      _showSuccessSnackBar('Profile updated successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error updating profile: ${e.toString()}');
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      _showErrorSnackBar('Error signing out: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading profile...'),
      );
    }

    if (_user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load profile'),
              const SizedBox(height: 16),
              AppButton(
                text: 'Retry',
                onPressed: _loadUserProfile,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 48.0 : 24.0),
        child: Column(
          children: [
            // Profile Header
            AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 60 : 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: _user!.photoURL != null
                        ? NetworkImage(_user!.photoURL!)
                        : null,
                    child: _user!.photoURL == null
                        ? Text(
                            _user!.displayName.isNotEmpty
                                ? _user!.displayName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user!.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _user!.role.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Information
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_isEditing) ...[
                        TextButton(
                          onPressed: () => setState(() => _isEditing = false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _updateProfile,
                          child: const Text('Save'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    labelText: 'Full Name',
                    controller: _nameController,
                    enabled: _isEditing,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    labelText: 'Email',
                    controller: _emailController,
                    enabled: false, // Email cannot be changed
                    prefixIcon: const Icon(Icons.email),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(
                    'Member Since',
                    '${_user!.createdAt.day}/${_user!.createdAt.month}/${_user!.createdAt.year}',
                    Icons.calendar_today,
                  ),
                  
                  _buildInfoRow(
                    'Last Login',
                    '${_user!.lastLogin.day}/${_user!.lastLogin.month}/${_user!.lastLogin.year}',
                    Icons.access_time,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            AppCard(
              child: Column(
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Order History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/orders'),
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Delivery Addresses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feature coming soon!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Payment Methods'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feature coming soon!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feature coming soon!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            AppButton(
              text: 'Sign Out',
              onPressed: _logout,
              backgroundColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
              height: isTablet ? 56 : 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
