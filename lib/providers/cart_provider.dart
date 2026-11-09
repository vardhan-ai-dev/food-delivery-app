import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (_items.isEmpty) return 0;
    return _items.first.restaurant.deliveryFee;
  }

  double get total => subtotal + deliveryFee;

  String get restaurantName =>
      _items.isNotEmpty ? _items.first.restaurant.name : '';

  void addItem(MenuItem menuItem, Restaurant restaurant) {
    // Check if adding from a different restaurant
    if (_items.isNotEmpty &&
        _items.first.restaurant.id != restaurant.id) {
      _items.clear();
    }

    final existingIndex =
        _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem, restaurant: restaurant));
    }
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
    notifyListeners();
  }

  void incrementQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  int getItemQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) return _items[index].quantity;
    return 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Order placeOrder() {
    final order = Order(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_items),
      totalAmount: total,
      orderTime: DateTime.now(),
    );
    _orders.insert(0, order);
    _items.clear();
    notifyListeners();
    return order;
  }
}
