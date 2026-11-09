import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/sample_data.dart';
import '../providers/cart_provider.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  final CartProvider cartProvider;
  final VoidCallback onCartChanged;

  const HomeScreen({
    super.key,
    required this.cartProvider,
    required this.onCartChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  List<Restaurant> get _filteredRestaurants {
    var list = sampleRestaurants;
    if (_selectedCategory != 'All') {
      list = list.where((r) => r.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((r) =>
              r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.cuisine.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  List<Restaurant> get _featuredRestaurants =>
      sampleRestaurants.where((r) => r.isFeatured).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('🍽️',
                            style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FoodDash',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14,
                                  color: theme.colorScheme.outline),
                              const SizedBox(width: 2),
                              Text(
                                'Delivering to Home',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or food...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Categories ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                itemCount: foodCategories.length,
                itemBuilder: (context, index) {
                  final cat = foodCategories[index];
                  final isSelected = _selectedCategory == cat.name;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = cat.name),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat.color
                                  : cat.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: cat.color.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(cat.emoji,
                                  style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? cat.color
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Promo Banner ──
          if (_searchQuery.isEmpty && _selectedCategory == 'All')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.75),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 16,
                        top: 10,
                        child: Opacity(
                          opacity: 0.15,
                          child: Text('🍔🍕🍣',
                              style: const TextStyle(fontSize: 60)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('🔥 Limited Offer',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                            const SizedBox(height: 8),
                            const Text('Get 40% OFF',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            const Text('On your first 3 orders!',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Featured ──
          if (_searchQuery.isEmpty && _selectedCategory == 'All') ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('⭐ Featured Restaurants',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _featuredRestaurants.length,
                  itemBuilder: (context, index) => _FeaturedCard(
                    restaurant: _featuredRestaurants[index],
                    onTap: () => _openRestaurant(_featuredRestaurants[index]),
                  ),
                ),
              ),
            ),
          ],

          // ── All Restaurants header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? '🏪 All Restaurants'
                        : '${foodCategories.firstWhere((c) => c.name == _selectedCategory).emoji} $_selectedCategory',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('${_filteredRestaurants.length} places',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
            ),
          ),

          // ── Restaurant List ──
          _filteredRestaurants.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text('😕',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No restaurants found',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= _filteredRestaurants.length) return null;
                      final r = _filteredRestaurants[index];
                      return _RestaurantCard(
                        restaurant: r,
                        onTap: () => _openRestaurant(r),
                      );
                    },
                    childCount: _filteredRestaurants.length + 1,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _openRestaurant(Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantScreen(
          restaurant: restaurant,
          cartProvider: widget.cartProvider,
          onCartChanged: widget.onCartChanged,
        ),
      ),
    );
  }
}

// ───────── Featured Card ─────────
class _FeaturedCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const _FeaturedCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: restaurant.accentColor.withOpacity(0.2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: restaurant.accentColor.withOpacity(0.1),
                  child: Center(
                      child: Text(restaurant.imageEmoji,
                          style: const TextStyle(fontSize: 48))),
                ),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: restaurant.accentColor.withOpacity(0.1),
                    child: Center(
                        child: Text(restaurant.imageEmoji,
                            style: const TextStyle(fontSize: 48))),
                  );
                },
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(restaurant.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(restaurant.cuisine,
                        style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.outline),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 13, color: Colors.amber.shade700),
                        const SizedBox(width: 3),
                        Text('${restaurant.rating}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time,
                            size: 12, color: theme.colorScheme.outline),
                        const SizedBox(width: 3),
                        Text(restaurant.deliveryTime,
                            style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.outline)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────── Restaurant List Card ─────────
class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const _RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerLow,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              // Restaurant image
              SizedBox(
                width: 90,
                height: 90,
                child: Image.network(
                  restaurant.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: restaurant.accentColor.withOpacity(0.1),
                    child: Center(
                        child: Text(restaurant.imageEmoji,
                            style: const TextStyle(fontSize: 36))),
                  ),
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: restaurant.accentColor.withOpacity(0.1),
                      child: Center(
                          child: Text(restaurant.imageEmoji,
                              style: const TextStyle(fontSize: 36))),
                    );
                  },
                ),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(restaurant.cuisine,
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.outline)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star,
                              size: 15, color: Colors.amber.shade700),
                          const SizedBox(width: 3),
                          Text(
                              '${restaurant.rating} (${restaurant.reviewCount})',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 10),
                          Icon(Icons.access_time,
                              size: 13, color: theme.colorScheme.outline),
                          const SizedBox(width: 3),
                          Text(restaurant.deliveryTime,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.chevron_right,
                    color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
