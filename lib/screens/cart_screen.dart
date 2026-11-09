import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final CartProvider cartProvider;
  final VoidCallback onCartChanged;
  final VoidCallback onNavigateToOrders;

  const CartScreen({
    super.key,
    required this.cartProvider,
    required this.onCartChanged,
    required this.onNavigateToOrders,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _address = 'Flat 402, Sunshine Apartments, MG Road, Bengaluru';
  String _pincode = '560001';
  String _paymentMethod = 'Google Pay (UPI)';
  final _couponController = TextEditingController();
  Order? _lastPlacedOrder;

  final List<Map<String, String>> _availableCoupons = [
    {
      'code': 'FOOD40',
      'title': '40% OFF',
      'desc': 'Save 40% up to ₹100',
    },
    {
      'code': 'WELCOME50',
      'title': '50% OFF',
      'desc': 'Save 50% up to ₹150',
    },
    {
      'code': 'FREESHIP',
      'title': 'FREE Delivery',
      'desc': '100% discount on delivery fee',
    },
    {
      'code': 'FLAT50',
      'title': '₹50 OFF',
      'desc': 'Flat ₹50 off on orders > ₹199',
    },
  ];

  final List<Map<String, String>> _savedAddresses = [
    {
      'title': 'Home',
      'address': 'Flat 402, Sunshine Apartments, MG Road, Bengaluru',
      'pincode': '560001',
    },
    {
      'title': 'Work',
      'address': 'Tech Park Phase 2, Tower B, Whitefield, Bengaluru',
      'pincode': '560066',
    },
    {
      'title': 'Other',
      'address': '12th Cross, Indiranagar, Bengaluru',
      'pincode': '560038',
    },
  ];

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'name': 'Google Pay (UPI)',
      'subtitle': 'Fast & secure UPI payment',
      'icon': Icons.account_balance,
      'color': Colors.blue,
    },
    {
      'name': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card,
      'color': Colors.purple,
    },
    {
      'name': 'Paytm / PhonePe Wallet',
      'subtitle': 'Instant checkout with wallet',
      'icon': Icons.account_balance_wallet,
      'color': Colors.teal,
    },
    {
      'name': 'Cash on Delivery (COD)',
      'subtitle': 'Pay in cash when food arrives',
      'icon': Icons.payments_outlined,
      'color': Colors.green,
    },
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(String code) {
    final error = widget.cartProvider.applyCoupon(code);
    widget.onCartChanged();
    setState(() {});

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } else {
      _couponController.text = code;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '🎉 Coupon $code applied! You saved ₹${widget.cartProvider.discountAmount.toStringAsFixed(0)}'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  void _removeCoupon() {
    widget.cartProvider.removeCoupon();
    _couponController.clear();
    widget.onCartChanged();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coupon removed')),
    );
  }

  void _showChangeAddressDialog() {
    final addrController = TextEditingController(text: _address);
    final pinController = TextEditingController(text: _pincode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Select Delivery Address',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ..._savedAddresses.map((sa) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      sa['title'] == 'Home'
                          ? Icons.home
                          : sa['title'] == 'Work'
                              ? Icons.work
                              : Icons.location_city,
                      color: Colors.blue,
                    ),
                    title: Text('${sa['title']} (${sa['pincode']})',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(sa['address']!,
                        style: const TextStyle(fontSize: 12)),
                    trailing: _address == sa['address']
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _address = sa['address']!;
                        _pincode = sa['pincode']!;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                )),
            const Divider(height: 20),
            Text('Or Enter Custom Address:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 8),
            TextField(
              controller: addrController,
              decoration: const InputDecoration(
                labelText: 'Street / Building / Area',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Pincode (6 digits)',
                prefixIcon: Icon(Icons.pin_drop_outlined),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final a = addrController.text.trim();
                final p = pinController.text.trim();
                if (a.isEmpty || p.isEmpty || p.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter valid address & 6-digit pincode')),
                  );
                  return;
                }
                setState(() {
                  _address = a;
                  _pincode = p;
                });
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Save Delivery Address'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePaymentDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Select Payment Method',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ..._paymentOptions.map((opt) {
              final isSelected = _paymentMethod == opt['name'];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected
                    ? (opt['color'] as Color).withOpacity(0.08)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected
                      ? BorderSide(color: opt['color'] as Color, width: 1.5)
                      : BorderSide.none,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (opt['color'] as Color).withOpacity(0.15),
                    child: Icon(opt['icon'] as IconData,
                        color: opt['color'] as Color),
                  ),
                  title: Text(opt['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(opt['subtitle'] as String,
                      style: const TextStyle(fontSize: 12)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _paymentMethod = opt['name'] as String;
                    });
                    Navigator.pop(ctx);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    if (_address.isEmpty || _pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select delivery address & pincode')),
      );
      return;
    }

    final order = widget.cartProvider.placeOrder(
      deliveryAddress: _address,
      pincode: _pincode,
      paymentMethod: _paymentMethod,
    );

    widget.onCartChanged();

    setState(() {
      _lastPlacedOrder = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.cartProvider;

    // ── Order Placed Success View ──
    if (_lastPlacedOrder != null) {
      final o = _lastPlacedOrder!;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Placed!'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green.shade200, width: 2),
                    ),
                    child: const Center(
                      child: Text('🎉', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Order Successfully Placed!',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Order ID: ${o.id}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Order Summary Card
                  Card(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.store,
                            title: 'Restaurant',
                            subtitle: o.restaurantName,
                            color: Colors.orange,
                          ),
                          const Divider(height: 16),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            title: 'Delivering to',
                            subtitle: '${o.deliveryAddress} - PIN ${o.pincode}',
                            color: Colors.blue,
                          ),
                          const Divider(height: 16),
                          _buildDetailRow(
                            icon: Icons.payment,
                            title: 'Payment Method',
                            subtitle: o.paymentMethod,
                            color: Colors.green,
                          ),
                          if (o.appliedCoupon != null) ...[
                            const Divider(height: 16),
                            _buildDetailRow(
                              icon: Icons.local_offer,
                              title: 'Coupon Applied',
                              subtitle: '${o.appliedCoupon} (Saved ₹${o.discountAmount.toStringAsFixed(0)})',
                              color: Colors.deepOrange,
                            ),
                          ],
                          const Divider(height: 16),
                          _buildDetailRow(
                            icon: Icons.currency_rupee,
                            title: 'Total Bill Paid',
                            subtitle: '₹${o.totalAmount.toStringAsFixed(0)}',
                            color: Colors.purple,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.amber),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Estimated Delivery: 25-35 minutes\nWatch live status in the Orders tab!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _lastPlacedOrder = null;
                      });
                      widget.onNavigateToOrders();
                    },
                    icon: const Icon(Icons.delivery_dining),
                    label: const Text('Track Live Order in Orders Tab'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _lastPlacedOrder = null;
                      });
                    },
                    child: const Text('Back to Cart'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ── Cart Empty View ──
    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
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
                'Explore restaurants and add yummy dishes!',
                style: TextStyle(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // ── Active Cart View with Address, Pincode, Coupons & Payment ──
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Restaurant name header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.store, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    cart.restaurantName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${cart.itemCount} items',
                    style: TextStyle(
                        fontSize: 12, color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Cart Items
            ...cart.items.map((item) => _CartItemTile(
                  cartItem: item,
                  onIncrement: () {
                    widget.cartProvider.incrementQuantity(item.menuItem.id);
                    widget.onCartChanged();
                    setState(() {});
                  },
                  onDecrement: () {
                    widget.cartProvider.decrementQuantity(item.menuItem.id);
                    widget.onCartChanged();
                    setState(() {});
                  },
                )),

            const SizedBox(height: 14),

            // ── Coupons & Offers Card ──
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_offer,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Offers & Coupons',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // If coupon already applied
                    if (cart.appliedCoupon != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coupon ${cart.appliedCoupon} Applied!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'You saved ₹${cart.discountAmount.toStringAsFixed(0)} on this order',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: _removeCoupon,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('REMOVE'),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Coupon Input Box
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'Enter code (e.g. FOOD40)',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              final c = _couponController.text.trim();
                              if (c.isNotEmpty) {
                                _applyCoupon(c);
                              }
                            },
                            child: const Text('APPLY'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Quick Tap Coupon Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableCoupons.map((ac) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                avatar: const Icon(Icons.discount_outlined,
                                    size: 16, color: Colors.orange),
                                label: Text('${ac['code']} • ${ac['title']}'),
                                onPressed: () {
                                  _applyCoupon(ac['code']!);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Delivery Address & Pincode Card ──
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Delivery Address & Pincode',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _showChangeAddressDialog,
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _address,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            'PIN: $_pincode',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimated: 25-35 mins',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Payment Method Card ──
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payment,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Payment Method',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _showChangePaymentDialog,
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          _paymentMethod.contains('UPI')
                              ? Icons.account_balance
                              : _paymentMethod.contains('Card')
                                  ? Icons.credit_card
                                  : _paymentMethod.contains('Cash')
                                      ? Icons.payments
                                      : Icons.account_balance_wallet,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _paymentMethod,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Spacer(),
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Bill Details Card ──
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bill Summary',
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
                        valueColor:
                            cart.deliveryFee == 0 ? Colors.green : null),
                    if (cart.appliedCoupon != null) ...[
                      const SizedBox(height: 4),
                      _BillRow(
                        label: 'Coupon Discount (${cart.appliedCoupon})',
                        value: '-₹${cart.discountAmount.toStringAsFixed(0)}',
                        valueColor: Colors.green,
                        isBold: true,
                      ),
                    ],
                    const Divider(height: 20),
                    _BillRow(
                      label: 'To Pay',
                      value: '₹${cart.total.toStringAsFixed(0)}',
                      isBold: true,
                      valueFontSize: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Fixed Bottom Checkout Button ──
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: _placeOrder,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place Order • ₹${cart.total.toStringAsFixed(0)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isBold ? 16 : 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  color: isBold ? color : null,
                ),
              ),
            ],
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Text(item.emoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
