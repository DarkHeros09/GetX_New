import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart extends GetxController {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change
      _items.update(
        productId,
        (exisitingCartItem) => CartItem(
            id: exisitingCartItem.id,
            title: exisitingCartItem.title,
            price: exisitingCartItem.price,
            quantity: exisitingCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    update();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    update();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (exisitingCartItem) => CartItem(
              id: exisitingCartItem.id,
              title: exisitingCartItem.title,
              quantity: exisitingCartItem.quantity - 1,
              price: exisitingCartItem.price));
    } else {
      _items.remove(productId);
    }
    update();
  }

  void clear() {
    _items = {};
    update();
  }
}
