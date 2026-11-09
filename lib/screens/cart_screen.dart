import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../models/models.dart';

class CartScreen extends StatefulWidget {
  final CartProvider cartProvider;
  final VoidCallback onCartChanged;

  const CartScreen({
    super.key,
    required this.cartProvider,
    required this.onCartChanged,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _orderPlaced = false;

  void _placeOrder() {
    final order = widget.cartProvider.placeOrder();
    widget.onCartChanged();
    setState(() => _orderPlaced = true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _orderPlaced = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.cartProvider;

    if (_orderPlaced) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                'Order Placed!',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your food is being prepared 👨‍🍳',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                widget.cartProvider.clearCart();
                widget.onCartChanged();
                setState(() {});
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear'),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items from a restaurant to get started',
                    style: TextStyle(color: theme.colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Restaurant name
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        cart.restaurantName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartItemTile(
                        cartItem: item,
                        onIncrement: () {
                          widget.cartProvider
                              .incrementQuantity(item.menuItem.id);
                          widget.onCartChanged();
                          setState(() {});
                        },
                        onDecrement: () {
                          widget.cartProvider
                              .decrementQuantity(item.menuItem.id);
                          widget.onCartChanged();
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
                // Bill summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Bill Details',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _BillRow(
                          label: 'Item Total',
                          value: '₹${cart.subtotal.toStringAsFixed(0)}'),
                      const SizedBox(height: 4),
                      _BillRow(
                          label: 'Delivery Fee',
                          value: cart.deliveryFee == 0
                              ? 'FREE'
                              : '₹${cart.deliveryFee.toStringAsFixed(0)}',
                          valueColor: cart.deliveryFee == 0
                              ? Colors.green
                              : null),
                      const Divider(height: 20),
                      _BillRow(
                        label: 'Total Amount',
                        value: '₹${cart.total.toStringAsFixed(0)}',
                        isBold: true,
                        valueFontSize: 18,
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: _placeOrder,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          'Place Order • ₹${cart.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemTile({
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = cartItem.menuItem;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Text(item.emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    '₹${item.price.toStringAsFixed(0)} each',
                    style: TextStyle(
                        fontSize: 12, color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${cartItem.totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: onDecrement,
                        color: theme.colorScheme.onPrimaryContainer,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                            minWidth: 32, minHeight: 32),
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: onIncrement,
                        color: theme.colorScheme.onPrimaryContainer,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                            minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  final double? valueFontSize;

  const _BillRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? null : theme.colorScheme.outline,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isBold ? theme.colorScheme.primary : null),
            fontSize: valueFontSize ?? (isBold ? 16 : 14),
          ),
        ),
      ],
    );
  }
}
