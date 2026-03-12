import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? shadowColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.surface;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12.0);
    final effectiveElevation = elevation ?? 2.0;
    final effectivePadding = padding ?? const EdgeInsets.all(16.0);

    Widget card = Card(
      color: effectiveColor,
      shadowColor: shadowColor,
      elevation: effectiveElevation,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: const BorderSide(style: BorderStyle.none),
      ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: card,
      );
    }

    if (margin != null) {
      card = Padding(
        padding: margin!,
        child: card,
      );
    }

    return card;
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return theme.colorScheme.secondary;
        case 'preparing':
          return theme.colorScheme.primary;
        case 'ready':
          return theme.colorScheme.secondary;
        case 'completed':
          return theme.colorScheme.primary;
        case 'cancelled':
          return theme.colorScheme.error;
        default:
          return theme.colorScheme.outline;
      }
    }

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$orderId',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                customerName,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
