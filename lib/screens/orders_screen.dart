import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(user.uid, ['pending', 'preparing', 'ready']),
          _buildOrdersList(user.uid, ['completed']),
          _buildOrdersList(user.uid, null),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewOrder,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOrdersList(String userId, List<String>? statuses) {
    return StreamBuilder<List<OrderModel>>(
      stream: _firestoreService.getUserOrders(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: 'Loading orders...');
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Retry',
                  onPressed: () => setState(() {}),
                ),
              ],
            ),
          );
        }

        final allOrders = snapshot.data ?? [];
        final filteredOrders = statuses != null
            ? allOrders.where((order) => statuses.contains(order.status.toString().split('.').last)).toList()
            : allOrders;

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${statuses != null ? statuses.first : ''} orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  statuses != null
                      ? 'You have no ${statuses.join(' or ')} orders'
                      : 'You have no orders yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (statuses == null) ...[
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Create First Order',
                    onPressed: _createNewOrder,
                  ),
                ],
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OrderCard(
                  orderId: order.id,
                  customerName: order.customerName,
                  totalAmount: order.totalAmount,
                  status: order.status.toString().split('.').last,
                  createdAt: order.createdAt,
                  onTap: () => _showOrderDetails(order),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _createNewOrder() {
    Navigator.pushNamed(context, '/menu');
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        order.status.toString().split('.').last.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildInfoRow(
                      context,
                      'Customer',
                      order.customerName,
                      Icons.person,
                    ),
                    _buildInfoRow(
                      context,
                      'Date',
                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                      Icons.calendar_today,
                    ),
                    _buildInfoRow(
                      context,
                      'Time',
                      '${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                      Icons.access_time,
                    ),
                    _buildInfoRow(
                      context,
                      'Total Amount',
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      Icons.attach_money,
                    ),
                    if (order.deliveryAddress != null) ...[
                      _buildInfoRow(
                        context,
                        'Delivery Address',
                        order.deliveryAddress!,
                        Icons.location_on,
                      ),
                    ],
                    if (order.notes != null) ...[
                      _buildInfoRow(
                        context,
                        'Notes',
                        order.notes!,
                        Icons.note,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'Order Items',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (item.notes != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.notes!,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'x${item.quantity}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '\$${item.subtotal.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),
                    if (order.status == OrderStatus.pending) ...[
                      AppButton(
                        text: 'Cancel Order',
                        onPressed: () => _cancelOrder(order.id),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Theme.of(context).colorScheme.onError,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
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

  Color _getStatusColor(OrderStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case OrderStatus.pending:
        return theme.colorScheme.secondary;
      case OrderStatus.preparing:
        return theme.colorScheme.primary;
      case OrderStatus.ready:
        return theme.colorScheme.secondary;
      case OrderStatus.completed:
        return theme.colorScheme.primary;
      case OrderStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await _firestoreService.updateOrder(
        OrderModel(
          id: orderId,
          customerId: '',
          customerName: '',
          items: [],
          totalAmount: 0,
          status: OrderStatus.cancelled,
          createdAt: DateTime.now(),
        ),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order cancelled successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling order: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
