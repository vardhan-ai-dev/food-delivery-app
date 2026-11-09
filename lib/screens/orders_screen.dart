import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../models/models.dart';

class OrdersScreen extends StatelessWidget {
  final CartProvider cartProvider;

  const OrdersScreen({super.key, required this.cartProvider});

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On The Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.onTheWay:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.done_all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orders = cartProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📦', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text('No orders yet',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Place your first order!',
                      style: TextStyle(color: theme.colorScheme.outline)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final statusColor = _statusColor(order.status);
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  color: theme.colorScheme.surfaceContainerLow,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.restaurantName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  const SizedBox(height: 2),
                                  Text(order.id,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.outline)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(_statusIcon(order.status),
                                      size: 14, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(_statusLabel(order.status),
                                      style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        // Order items
                        ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Text(item.menuItem.emoji,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(item.menuItem.name,
                                          style: const TextStyle(
                                              fontSize: 13))),
                                  Text('x${item.quantity}',
                                      style: TextStyle(
                                          color: theme.colorScheme.outline,
                                          fontSize: 13)),
                                  const SizedBox(width: 10),
                                  Text(
                                      '₹${item.totalPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ],
                              ),
                            )),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                  color: theme.colorScheme.outline,
                                  fontSize: 13),
                            ),
                            Text(
                              'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        // Progress bar
                        const SizedBox(height: 14),
                        _OrderProgressBar(status: order.status),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _OrderProgressBar extends StatelessWidget {
  final OrderStatus status;

  const _OrderProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['Placed', 'Preparing', 'On the Way', 'Delivered'];
    final currentStep = status.index;

    return Row(
      children: steps.asMap().entries.map((e) {
        final i = e.key;
        final isCompleted = i <= currentStep;
        final isCurrent = i == currentStep;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      border: isCurrent
                          ? Border.all(color: Colors.green, width: 2)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isCompleted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCompleted
                          ? Colors.green
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i < currentStep
                        ? Colors.green
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
