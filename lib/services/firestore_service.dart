import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User operations
  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to save user: ${e.toString()}';
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: ${e.toString()}';
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw 'Failed to update user: ${e.toString()}';
    }
  }

  // Order operations
  Future<String> createOrder(OrderModel order) async {
    try {
      final DocumentReference docRef = await _db.collection('orders').add(order.toMap());
      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: ${e.toString()}';
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _db.collection('orders').doc(order.id).update(order.toMap());
    } catch (e) {
      throw 'Failed to update order: ${e.toString()}';
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw 'Failed to delete order: ${e.toString()}';
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data()))
            .toList());
  }

  Stream<OrderModel?> getOrderStream(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? OrderModel.fromMap(snapshot.data() as Map<String, dynamic>)
            : null);
  }

  Future<OrderModel?> getOrder(String orderId) async {
    try {
      final DocumentSnapshot doc = await _db.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get order: ${e.toString()}';
    }
  }

  // Vendor operations
  Stream<List<OrderModel>> getVendorOrders(String vendorId) {
    return _db
        .collection('orders')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data()))
            .toList());
  }

  // Analytics
  Future<Map<String, int>> getOrderStats(String userId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('orders')
          .where('customerId', isEqualTo: userId)
          .get();

      final Map<String, int> stats = {
        'total': snapshot.docs.length,
        'pending': 0,
        'preparing': 0,
        'ready': 0,
        'completed': 0,
        'cancelled': 0,
      };

      for (final doc in snapshot.docs) {
        final order = OrderModel.fromMap(doc.data()! as Map<String, dynamic>);
        final status = order.status.toString().split('.').last;
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw 'Failed to get order stats: ${e.toString()}';
    }
  }
}
