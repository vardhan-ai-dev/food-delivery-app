import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  String? _appliedCoupon;
  double _discountAmount = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  String? get appliedCoupon => _appliedCoupon;
  double get discountAmount => _discountAmount;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (_items.isEmpty) return 0;
    // If FREESHIP coupon is applied, delivery is 0!
    if (_appliedCoupon == 'FREESHIP') return 0;
    return _items.first.restaurant.deliveryFee;
  }

  double get total {
    if (_items.isEmpty) return 0;
    final totalBeforeDiscount = subtotal + deliveryFee;
    final finalTotal = totalBeforeDiscount - _discountAmount;
    return finalTotal < 0 ? 0 : finalTotal;
  }

  String get restaurantName =>
      _items.isNotEmpty ? _items.first.restaurant.name : '';

  void addItem(MenuItem menuItem, Restaurant restaurant) {
    if (_items.isNotEmpty &&
        _items.first.restaurant.id != restaurant.id) {
      _items.clear();
      _appliedCoupon = null;
      _discountAmount = 0.0;
    }

    final existingIndex =
        _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem, restaurant: restaurant));
    }
    _recalculateDiscount();
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
    if (_items.isEmpty) {
      _appliedCoupon = null;
      _discountAmount = 0.0;
    } else {
      _recalculateDiscount();
    }
    notifyListeners();
  }

  void incrementQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity++;
      _recalculateDiscount();
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
      if (_items.isEmpty) {
        _appliedCoupon = null;
        _discountAmount = 0.0;
      } else {
        _recalculateDiscount();
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
    _appliedCoupon = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  String? applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    if (_items.isEmpty) {
      return 'Add items to cart before applying coupons';
    }

    if (code == 'FOOD40') {
      // 40% OFF up to ₹100
      final calculated = subtotal * 0.40;
      _discountAmount = calculated > 100 ? 100.0 : calculated;
      _appliedCoupon = 'FOOD40';
      notifyListeners();
      return null;
    } else if (code == 'WELCOME50') {
      // 50% OFF up to ₹150
      final calculated = subtotal * 0.50;
      _discountAmount = calculated > 150 ? 150.0 : calculated;
      _appliedCoupon = 'WELCOME50';
      notifyListeners();
      return null;
    } else if (code == 'FREESHIP') {
      // Free delivery
      final originalFee = _items.first.restaurant.deliveryFee;
      _discountAmount = originalFee;
      _appliedCoupon = 'FREESHIP';
      notifyListeners();
      return null;
    } else if (code == 'FLAT50') {
      // Flat ₹50 off on orders above ₹199
      if (subtotal < 199) {
        return 'Order must be above ₹199 for FLAT50';
      }
      _discountAmount = 50.0;
      _appliedCoupon = 'FLAT50';
      notifyListeners();
      return null;
    } else {
      return 'Invalid coupon code. Try FOOD40, WELCOME50, or FREESHIP';
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_appliedCoupon != null) {
      applyCoupon(_appliedCoupon!);
    }
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
      appliedCoupon: _appliedCoupon,
      discountAmount: _discountAmount,
      status: OrderStatus.placed,
    );
    _orders.insert(0, order);
    _items.clear();
    _appliedCoupon = null;
    _discountAmount = 0.0;
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
