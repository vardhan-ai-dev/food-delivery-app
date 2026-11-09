import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';

class OrdersScreen extends StatefulWidget {
  final CartProvider cartProvider;

  const OrdersScreen({super.key, required this.cartProvider});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing Food';
      case OrderStatus.onTheWay:
        return 'On The Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String _statusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order received by restaurant. Preparing will start shortly.';
      case OrderStatus.preparing:
        return 'Chef is cooking your fresh meal in the kitchen 🍳';
      case OrderStatus.onTheWay:
        return 'Delivery executive is driving to your address 🛵';
      case OrderStatus.delivered:
        return 'Order delivered! Enjoy your meal 🎉';
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
        return Icons.receipt_long;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orders = widget.cartProvider.orders;

    // Listen to changes for real-time progress updates
    return ListenableBuilder(
      listenable: widget.cartProvider,
      builder: (context, _) {
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
                      Text(
                        'Add items to cart and place an order to track it live!',
                        style: TextStyle(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final statusColor = _statusColor(order.status);
                    final isDelivered =
                        order.status == OrderStatus.delivered;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with ID & Live Status Badge
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.restaurantName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'ID: ${order.id} • ${_formatTime(order.orderTime)}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: theme.colorScheme.outline),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: statusColor.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_statusIcon(order.status),
                                          size: 14, color: statusColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        _statusLabel(order.status),
                                        style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Address & Pincode + Payment banner
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme
                                    .colorScheme.surfaceContainerHighest
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.blue),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          '${order.deliveryAddress} - PIN ${order.pincode}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.payment,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Paid via ${order.paymentMethod}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Divider(height: 20),

                            // Order Items
                            ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.network(
                                            item.menuItem.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Text(item.menuItem.emoji,
                                                    style: const TextStyle(
                                                        fontSize: 18)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item.menuItem.name,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Text('x${item.quantity}',
                                          style: TextStyle(
                                              color: theme.colorScheme.outline,
                                              fontSize: 12)),
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

                            // Total Bill Row
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      color: theme.colorScheme.outline,
                                      fontSize: 13),
                                ),
                                Text(
                                  'Total Paid: ₹${order.totalAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Status message box
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(_statusIcon(order.status),
                                      size: 14, color: statusColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _statusMessage(order.status),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 4-Step Interactive Progress Tracker
                            _OrderProgressBar(status: order.status),

                            // Simulation Button (Great for Viva/Demo!)
                            if (!isDelivered) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    widget.cartProvider
                                        .advanceOrderStatus(order.id);
                                  },
                                  icon: const Icon(Icons.fast_forward, size: 16),
                                  label: const Text(
                                    'Simulate Next Stage ⚡',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
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
