import 'dart:async';
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

  Order placeOrder({
    required String deliveryAddress,
    required String pincode,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(_items),
      totalAmount: total,
      orderTime: DateTime.now(),
      deliveryAddress: deliveryAddress,
      pincode: pincode,
      paymentMethod: paymentMethod,
      status: OrderStatus.placed,
    );
    _orders.insert(0, order);
    _items.clear();
    notifyListeners();

    // Automatically simulate delivery stages:
    // Placed -> Preparing (after 4s) -> On the Way (after 9s) -> Delivered (after 16s)
    Timer(const Duration(seconds: 4), () {
      if (order.status == OrderStatus.placed) {
        order.status = OrderStatus.preparing;
        notifyListeners();
      }
    });

    Timer(const Duration(seconds: 9), () {
      if (order.status == OrderStatus.preparing) {
        order.status = OrderStatus.onTheWay;
        notifyListeners();
      }
    });

    Timer(const Duration(seconds: 16), () {
      if (order.status == OrderStatus.onTheWay) {
        order.status = OrderStatus.delivered;
        notifyListeners();
      }
    });

    return order;
  }

  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final current = _orders[index].status;
      if (current == OrderStatus.placed) {
        _orders[index].status = OrderStatus.preparing;
      } else if (current == OrderStatus.preparing) {
        _orders[index].status = OrderStatus.onTheWay;
      } else if (current == OrderStatus.onTheWay) {
        _orders[index].status = OrderStatus.delivered;
      }
      notifyListeners();
    }
  }
}
