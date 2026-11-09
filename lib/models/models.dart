import 'package:flutter/material.dart';

// ───────────── Category ─────────────
class FoodCategory {
  final String name;
  final String emoji;
  final Color color;

  const FoodCategory({
    required this.name,
    required this.emoji,
    required this.color,
  });
}

const List<FoodCategory> foodCategories = [
  FoodCategory(name: 'All', emoji: '🍽️', color: Color(0xFFFF6B35)),
  FoodCategory(name: 'Pizza', emoji: '🍕', color: Color(0xFFE53935)),
  FoodCategory(name: 'Burger', emoji: '🍔', color: Color(0xFFFF8F00)),
  FoodCategory(name: 'Sushi', emoji: '🍣', color: Color(0xFFE91E63)),
  FoodCategory(name: 'Indian', emoji: '🍛', color: Color(0xFFFF6F00)),
  FoodCategory(name: 'Chinese', emoji: '🥡', color: Color(0xFFD32F2F)),
  FoodCategory(name: 'Dessert', emoji: '🍰', color: Color(0xFF8E24AA)),
  FoodCategory(name: 'Drinks', emoji: '🥤', color: Color(0xFF00897B)),
];

// ───────────── Restaurant ─────────────
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String category;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final String imageEmoji;
  final String imageUrl;
  final Color accentColor;
  final bool isFeatured;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.imageEmoji,
    required this.imageUrl,
    required this.accentColor,
    this.isFeatured = false,
    required this.menu,
  });
}

// ───────────── Menu Item ─────────────
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String imageUrl;
  final bool isVeg;
  final bool isBestseller;
  final String? tag;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.imageUrl,
    this.isVeg = false,
    this.isBestseller = false,
    this.tag,
  });
}

// ───────────── Cart Item ─────────────
class CartItem {
  final MenuItem menuItem;
  final Restaurant restaurant;
  int quantity;

  CartItem({
    required this.menuItem,
    required this.restaurant,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
}

// ───────────── Order ─────────────
enum OrderStatus { placed, preparing, onTheWay, delivered }

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderTime;
  final String deliveryAddress;
  final String pincode;
  final String paymentMethod;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderTime,
    this.deliveryAddress = 'Flat 402, Sunshine Apartments, MG Road, Bengaluru',
    this.pincode = '560001',
    this.paymentMethod = 'Google Pay (UPI)',
    this.status = OrderStatus.placed,
  });

  String get restaurantName =>
      items.isNotEmpty ? items.first.restaurant.name : '';
}
