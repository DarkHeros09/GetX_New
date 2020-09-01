import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';
import '../auth/auth.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders extends GetxController {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token = Get.find<Auth>().token;
  final String userId = Get.find<Auth>().userId;

  Future<void> fetchOrders() async {
    final url =
        'https://firedata-95380.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData.isNull) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrder.reversed.toList();
    update();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://firedata-95380.firebaseio.com/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    update();
  }
}
