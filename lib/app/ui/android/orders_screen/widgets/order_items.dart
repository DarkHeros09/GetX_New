import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../../../../controller/cart/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;
  OrderItem({this.order});
  // final ord.Orders orderData = Get.put(ord.Orders());
  final _isExpand = false.obs;
  bool get isExpand => _isExpand.value;
  changeExpand() => _isExpand.value = !_isExpand.value;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
                icon: Obx(
                  () => Icon(isExpand ? Icons.expand_less : Icons.expand_more),
                ),
                onPressed: () {
                  changeExpand();
                }),
          ),
          Obx(
            () => isExpand
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    height: min(order.products.length * 20.0 + 10, 100),
                    child: ListView(
                      children: order.products
                          .map(
                            (prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${prod.quantity}x \$${prod.price}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
