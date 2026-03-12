enum OrderStatus { pending, preparing, ready, completed, cancelled }

enum OrderType { delivery, pickup }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final OrderType type;
  final String? deliveryAddress;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? vendorId;
  final String? notes;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    this.type = OrderType.pickup,
    this.deliveryAddress,
    required this.createdAt,
    this.completedAt,
    this.vendorId,
    this.notes,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${map['status']}',
        orElse: () => OrderStatus.pending,
      ),
      type: OrderType.values.firstWhere(
        (e) => e.toString() == 'OrderType.${map['type']}',
        orElse: () => OrderType.pickup,
      ),
      deliveryAddress: map['deliveryAddress'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      completedAt: map['completedAt']?.toDate(),
      vendorId: map['vendorId'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'deliveryAddress': deliveryAddress,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'vendorId': vendorId,
      'notes': notes,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    OrderType? type,
    String? deliveryAddress,
    DateTime? createdAt,
    DateTime? completedAt,
    String? vendorId,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      type: type ?? this.type,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      vendorId: vendorId ?? this.vendorId,
      notes: notes ?? this.notes,
    );
  }
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String? notes;

  const OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes,
    };
  }

  double get subtotal => price * quantity;

  OrderItem copyWith({
    String? name,
    double? price,
    int? quantity,
    String? notes,
  }) {
    return OrderItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}
