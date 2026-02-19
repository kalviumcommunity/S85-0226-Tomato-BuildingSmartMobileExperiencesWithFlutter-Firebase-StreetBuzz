import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get usersCollection => _db.collection('users');
  CollectionReference get ordersCollection => _db.collection('orders');

  // ==================== USER OPERATIONS ====================

  // Create or update user data
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error adding user data: $e');
    }
  }

  // Get user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await usersCollection.doc(uid).get();
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).update(data);
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }

  // Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('Error deleting user data: $e');
    }
  }

  // ==================== ORDER OPERATIONS ====================

  // Create a new order
  Future<DocumentReference> createOrder(Map<String, dynamic> orderData) async {
    try {
      return await ordersCollection.add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // Get orders for a specific user
  Stream<QuerySnapshot> getUserOrders(String userId) {
    try {
      return ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception('Error getting user orders: $e');
    }
  }

  // Get all orders (for vendors)
  Stream<QuerySnapshot> getAllOrders() {
    try {
      return ordersCollection
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception('Error getting all orders: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await ordersCollection.doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await ordersCollection.doc(orderId).delete();
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  // ==================== REAL-TIME LISTENERS ====================

  // Listen to user data changes
  Stream<DocumentSnapshot> listenToUserData(String uid) {
    return usersCollection.doc(uid).snapshots();
  }

  // Listen to specific order changes
  Stream<DocumentSnapshot> listenToOrder(String orderId) {
    return ordersCollection.doc(orderId).snapshots();
  }
}
