import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';
import 'restaurant_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int) onNavigateToTab;
  final CartProvider cartProvider;
  final VoidCallback onCartChanged;

  const ProfileScreen({
    super.key,
    required this.onNavigateToTab,
    required this.cartProvider,
    required this.onCartChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';
  String _userPhone = '+91 98765 43210';

  final List<String> _favoriteRestaurantIds = ['r1', 'r3', 'r5'];

  final List<Map<String, String>> _addresses = [
    {
      'title': 'Home',
      'address': 'Flat 402, Sunshine Apartments, MG Road, Bengaluru',
      'icon': 'home',
    },
    {
      'title': 'Work',
      'address': 'Tech Park Phase 2, Tower B, Whitefield, Bengaluru',
      'icon': 'work',
    },
    {
      'title': 'Other',
      'address': '12th Cross, Indiranagar, Bengaluru',
      'icon': 'location_on',
    },
  ];

  final List<Map<String, String>> _paymentMethods = [
    {
      'name': 'Google Pay (UPI)',
      'detail': 'john.doe@okaxis',
      'icon': 'gpay',
    },
    {
      'name': 'HDFC Bank Credit Card',
      'detail': '•••• •••• •••• 4242 (Expires 08/28)',
      'icon': 'card',
    },
    {
      'name': 'Paytm Wallet',
      'detail': 'Balance: ₹1,250',
      'icon': 'wallet',
    },
    {
      'name': 'Cash on Delivery',
      'detail': 'Pay with cash upon arrival',
      'icon': 'cash',
    },
  ];

  final List<Map<String, String>> _coupons = [
    {
      'code': 'FOOD40',
      'discount': '40% OFF up to ₹100',
      'desc': 'Valid on orders above ₹249',
    },
    {
      'code': 'WELCOME50',
      'discount': '50% OFF up to ₹150',
      'desc': 'First order special discount',
    },
    {
      'code': 'FREESHIP',
      'discount': 'FREE Delivery',
      'desc': 'On all orders from featured restaurants',
    },
  ];

  final List<Map<String, dynamic>> _userReviews = [
    {
      'restaurant': 'Pizza Paradise',
      'rating': 5.0,
      'date': 'Yesterday',
      'dish': 'Margherita Pizza & Garlic Bread',
      'comment': 'The crust was so crispy and the cheese pull was heavenly! Best pizza in town.',
    },
    {
      'restaurant': 'Spice Garden',
      'rating': 4.5,
      'date': '3 days ago',
      'dish': 'Chicken Biryani',
      'comment': 'Super fragrant rice with juicy chicken. Delivered steaming hot in 25 mins.',
    },
    {
      'restaurant': 'Sakura Sushi',
      'rating': 5.0,
      'date': '1 week ago',
      'dish': 'Salmon Nigiri & Ramen',
      'comment': 'Authentic taste! The salmon was fresh and melted in mouth. Will order again!',
    },
  ];

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text.trim();
                _userEmail = emailController.text.trim();
                _userPhone = phoneController.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFavouritesSheet() {
    final favRestaurants = sampleRestaurants
        .where((r) => _favoriteRestaurantIds.contains(r.id))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    'Favorite Restaurants (${favRestaurants.length})',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: favRestaurants.length,
                  itemBuilder: (context, index) {
                    final r = favRestaurants[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantScreen(
                                restaurant: r,
                                cartProvider: widget.cartProvider,
                                onCartChanged: widget.onCartChanged,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: Image.network(
                                r.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: r.accentColor.withOpacity(0.1),
                                  child: Center(
                                    child: Text(r.imageEmoji,
                                        style: const TextStyle(fontSize: 32)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r.cuisine,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color: Colors.amber.shade700),
                                      const SizedBox(width: 3),
                                      Text('${r.rating}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      const SizedBox(width: 10),
                                      Text('•  ${r.deliveryTime}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _favoriteRestaurantIds.remove(r.id);
                                });
                                Navigator.pop(ctx);
                                _showFavouritesSheet();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    'My Reviews (${_userReviews.length})',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _userReviews.length,
                  itemBuilder: (context, index) {
                    final rev = _userReviews[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rev['restaurant'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 14,
                                          color: Colors.amber.shade900),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${rev['rating']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.amber.shade900),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ordered: ${rev['dish']} • ${rev['date']}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '"${rev['comment']}"',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Saved Addresses',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._addresses.map((addr) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        addr['icon'] == 'home'
                            ? Icons.home
                            : addr['icon'] == 'work'
                                ? Icons.work
                                : Icons.location_on,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(addr['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(addr['address']!,
                        style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                  ),
                )),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Address management is active!')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSheet() {
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
                  'Payment Methods',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._paymentMethods.map((pm) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: Icon(
                        pm['icon'] == 'card'
                            ? Icons.credit_card
                            : pm['icon'] == 'wallet'
                                ? Icons.account_balance_wallet
                                : pm['icon'] == 'cash'
                                    ? Icons.money
                                    : Icons.account_balance,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(pm['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(pm['detail']!,
                        style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                  ),
                )),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Card/UPI linked successfully!')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Method'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCouponsSheet() {
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
                const Icon(Icons.local_offer, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Offers & Coupons',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._coupons.map((c) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.orange.shade50.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.orange.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  c['code']!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(c['discount']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Text(c['desc']!,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Coupon ${c['code']} copied!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text('COPY'),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet() {
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
                const Icon(Icons.notifications, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Notifications',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.delivery_dining, color: Colors.white),
              ),
              title: Text('Order Delivered! 🎉',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Your Pizza Paradise order has been delivered.'),
            ),
            const Divider(),
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.local_offer, color: Colors.white),
              ),
              title: Text('40% OFF Weekend Deal 🍔',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Use code FOOD40 for up to ₹100 off today!'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.teal),
            SizedBox(width: 8),
            Text('Help & Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frequently Asked Questions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• How do I track my order?'),
            Text('  Go to the "Orders" tab to see real-time progress.'),
            SizedBox(height: 6),
            Text('• Can I cancel an order?'),
            Text('  Orders can be cancelled before preparation starts.'),
            SizedBox(height: 6),
            Text('• Support Helpline:'),
            Text('  📞 1800-FOOD-DASH (Toll-Free, 24/7)'),
            Text('  ✉️ support@fooddash.com'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'FoodDash',
      applicationVersion: '1.0.0',
      applicationIcon: const Text('🍽️', style: TextStyle(fontSize: 40)),
      children: const [
        Text(
          'FoodDash is a modern, responsive Food Delivery Flutter Web application built with Material Design 3.',
        ),
        SizedBox(height: 8),
        Text('Features: Categories, Restaurant listings, Menu items with real photos, Cart management, Order tracking, and User Profile.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── App Bar Title ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Profile',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // ── Profile Header Card ──
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: const Text('👤', style: TextStyle(fontSize: 36)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(_userEmail,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(_userPhone,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: _showEditProfileDialog,
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
          ),

          // ── Stats Row (All Clickable!) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard(
                  context,
                  emoji: '🛍️',
                  value: '${widget.cartProvider.orders.isEmpty ? 24 : widget.cartProvider.orders.length}',
                  label: 'Orders',
                  color: Colors.deepOrange,
                  onTap: () {
                    // Navigate directly to the Orders tab (index 2)
                    widget.onNavigateToTab(2);
                  },
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  context,
                  emoji: '❤️',
                  value: '${_favoriteRestaurantIds.length}',
                  label: 'Favourites',
                  color: Colors.red,
                  onTap: _showFavouritesSheet,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  context,
                  emoji: '⭐',
                  value: '${_userReviews.length}',
                  label: 'Reviews',
                  color: Colors.amber,
                  onTap: _showReviewsSheet,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Settings Menu ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Settings & Preferences',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'Saved Addresses',
                    subtitle: '${_addresses.length} addresses saved',
                    color: Colors.blue,
                    onTap: _showAddressesSheet,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.payment_outlined,
                    label: 'Payment Methods',
                    subtitle: 'Cards, UPI & Wallets',
                    color: Colors.green,
                    onTap: _showPaymentSheet,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.local_offer_outlined,
                    label: 'Offers & Coupons',
                    subtitle: '${_coupons.length} active coupons available',
                    color: Colors.orange,
                    onTap: _showCouponsSheet,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    label: 'Favourites',
                    subtitle: 'View your saved restaurants',
                    color: Colors.red,
                    onTap: _showFavouritesSheet,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    subtitle: 'Manage delivery and promo alerts',
                    color: Colors.purple,
                    onTap: _showNotificationsSheet,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    subtitle: 'FAQs, toll-free number & chat',
                    color: Colors.teal,
                    onTap: _showHelpDialog,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    label: 'About FoodDash',
                    subtitle: 'Version 1.0.0 • Tech details',
                    color: Colors.grey,
                    onTap: _showAboutDialog,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Logout Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully!')),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red, size: 20),
              label: const Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String emoji,
    required String value,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: color),
                ),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
