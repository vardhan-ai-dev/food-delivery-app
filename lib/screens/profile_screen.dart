import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final menuItems = [
      _ProfileMenuItem(
          icon: Icons.location_on_outlined,
          label: 'Saved Addresses',
          subtitle: 'Home, Work, Other',
          color: Colors.blue),
      _ProfileMenuItem(
          icon: Icons.payment_outlined,
          label: 'Payment Methods',
          subtitle: 'Cards, UPI, Wallets',
          color: Colors.green),
      _ProfileMenuItem(
          icon: Icons.local_offer_outlined,
          label: 'Offers & Coupons',
          subtitle: '3 active offers',
          color: Colors.orange),
      _ProfileMenuItem(
          icon: Icons.favorite_outline,
          label: 'Favourites',
          subtitle: 'Your saved restaurants',
          color: Colors.red),
      _ProfileMenuItem(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          subtitle: 'Manage alerts',
          color: Colors.purple),
      _ProfileMenuItem(
          icon: Icons.help_outline,
          label: 'Help & Support',
          subtitle: 'FAQs, chat with us',
          color: Colors.teal),
      _ProfileMenuItem(
          icon: Icons.info_outline,
          label: 'About FoodDash',
          subtitle: 'Version 1.0.0',
          color: Colors.grey),
    ];

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
                    children: const [
                      Text(
                        'John Doe',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('john.doe@example.com',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 2),
                      Text('+91 98765 43210',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
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

          // ── Stats Row ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard(context, '🛍️', '24', 'Orders', Colors.deepOrange),
                const SizedBox(width: 10),
                _buildStatCard(context, '❤️', '8', 'Favourites', Colors.red),
                const SizedBox(width: 10),
                _buildStatCard(context, '⭐', '12', 'Reviews', Colors.amber),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Settings Menu ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Settings',
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
                children: menuItems.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.only(
                          topLeft:
                              i == 0 ? const Radius.circular(16) : Radius.zero,
                          topRight:
                              i == 0 ? const Radius.circular(16) : Radius.zero,
                          bottomLeft: i == menuItems.length - 1
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomRight: i == menuItems.length - 1
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item.icon,
                                    color: item.color, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.outline),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: theme.colorScheme.outline, size: 20),
                            ],
                          ),
                        ),
                      ),
                      if (i < menuItems.length - 1)
                        Divider(
                          height: 1,
                          indent: 56,
                          color: theme.colorScheme.outlineVariant
                              .withOpacity(0.4),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Logout Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
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
      BuildContext context, String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: color),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline),
            ),
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
  final Color color;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });
}
