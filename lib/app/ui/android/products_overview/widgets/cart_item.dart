import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/cart/cart.dart';

import '../../../theme/app_theme.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.productId, this.price, this.quantity, this.title});
  final Cart cart = Get.put(Cart());
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: appThemeData.errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return Get.defaultDialog(
          title: 'Are You Sure?',
          radius: 5,
          content: Text(
            'Do you want to remove the item from the cart?',
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: Text('Yes')),
            FlatButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
