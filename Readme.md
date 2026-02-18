# StreetBuzz 🍔

**StreetBuzz** is a real-time order management app designed to help street food vendors manage rush-hour queues and allow customers to order digitally.

## 📂 Folder Structure
We use a feature-first modular structure to keep UI and Logic separate:

- **`lib/screens/`**: Contains full-page widgets (e.g., `WelcomeScreen`). This separates page layout from individual components.
- **`lib/widgets/`**: Reusable UI elements (e.g., Buttons, OrderCards). Keeps code DRY (Don't Repeat Yourself).
- **`lib/services/`**: Will contain Firebase Auth and Firestore logic. This ensures our UI code doesn't handle direct database calls.
- **`lib/models/`**: Data definitions to ensure type safety across the app.
=