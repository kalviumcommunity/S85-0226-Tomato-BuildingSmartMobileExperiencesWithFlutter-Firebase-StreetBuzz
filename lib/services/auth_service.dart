import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<User?> signUp(String email, String password, {String? name}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore with merge: true
        try {
          await _firestore.collection('users').doc(credential.user!.uid).set({
            'email': email,
            'name': name ?? 'User',
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
            'profileCompleted': false,
            'isActive': true,
          }, SetOptions(merge: true));
          
          debugPrint('User document created for UID: ${credential.user!.uid}');
        } catch (firestoreError) {
          debugPrint('Firestore error during signup: $firestoreError');
          // Don't throw - user was created in Auth, just log the error
        }
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Signup error: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password must be at least 6 characters long.';
          break;
        case 'email-already-in-use':
          message = 'An account with this email already exists.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Please try again later.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign up.';
      }
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected signup error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update last login in Firestore with error handling
        try {
          await _firestore.collection('users').doc(credential.user!.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
            'isActive': true,
          });
          debugPrint('User logged in: ${credential.user!.uid}');
        } catch (firestoreError) {
          debugPrint('Firestore error during login update: $firestoreError');
          // Don't throw - login was successful, just log error
        }
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email address.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
        default:
          message = e.message ?? 'An error occurred during login.';
      }
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Logout error: $e');
      throw Exception('An error occurred during logout: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        default:
          message = e.message ?? 'An error occurred sending password reset email.';
      }
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected password reset error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Get user data from Firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      debugPrint('Error getting user data: $e');
      throw Exception('Error getting user data: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      debugPrint('User data updated for UID: $uid');
    } catch (e) {
      debugPrint('Error updating user data: $e');
      throw Exception('Error updating user data: $e');
    }
  }
}
