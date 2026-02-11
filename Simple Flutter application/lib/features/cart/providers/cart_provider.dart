import 'package:flutter/material.dart';
import 'package:laundry_app/core/models/service_model.dart';

class CartItem {
  final ServiceModel service;
  int quantity;

  CartItem({required this.service, this.quantity = 1});

  double get totalPrice => service.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(ServiceModel service) {
    if (_items.containsKey(service.id)) {
      _items.update(
        service.id,
        (existingCartItem) => CartItem(
          service: existingCartItem.service,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        service.id,
        () => CartItem(service: service),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
  
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          service: existingCartItem.service,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
