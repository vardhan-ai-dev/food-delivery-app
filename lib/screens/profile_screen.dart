import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final menuItems = [
      _ProfileMenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', subtitle: 'Home, Work, Other'),
      _ProfileMenuItem(icon: Icons.payment_outlined, label: 'Payment Methods', subtitle: 'Cards, UPI, Wallets'),
      _ProfileMenuItem(icon: Icons.local_offer_outlined, label: 'Offers & Coupons', subtitle: '3 active offers'),
      _ProfileMenuItem(icon: Icons.favorite_outline, label: 'Favourites', subtitle: 'Your saved restaurants'),
      _ProfileMenuItem(icon: Icons.notifications_outlined, label: 'Notifications', subtitle: 'Manage alerts'),
      _ProfileMenuItem(icon: Icons.help_outline, label: 'Help & Support', subtitle: 'FAQs, chat with us'),
      _ProfileMenuItem(icon: Icons.info_outline, label: 'About FoodDash', subtitle: 'Version 1.0.0'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'john.doe@example.com',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '+91 98765 43210',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      emoji: '🛍️',
                      label: 'Orders',
                      value: '24',
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      emoji: '❤️',
                      label: 'Favourites',
                      value: '8',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      emoji: '⭐',
                      label: 'Reviews',
                      value: '12',
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: theme.colorScheme.surfaceContainerLow,
                child: Column(
                  children: menuItems.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon,
                                color: theme.colorScheme.primary, size: 20),
                          ),
                          title: Text(item.label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          subtitle: Text(item.subtitle,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.outline)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        if (i < menuItems.length - 1)
                          Divider(
                              height: 1,
                              indent: 56,
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.5)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Log Out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final String subtitle;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}
