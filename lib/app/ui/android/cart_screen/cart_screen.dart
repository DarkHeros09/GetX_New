import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/cart/cart.dart' show Cart;
import 'package:getx_pattern/app/controller/cart/orders.dart';

import '../../theme/app_theme.dart';
import '../products_overview/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  final Orders orders = Get.put(Orders());
  final Cart cart = Get.put(Cart());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: GetBuilder(
                        init: cart,
                        builder: (_) => Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: appThemeData
                                  .primaryTextTheme.headline6.color),
                        ),
                      ),
                      backgroundColor: appThemeData.primaryColor,
                    ),
                    OrderButton(cart: cart, orders: orders)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GetBuilder(
                init: cart,
                builder: (_) => ListView.builder(
                  itemBuilder: (ctx, index) => CartItem(
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price,
                  ),
                  itemCount: cart.items.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  OrderButton({
    @required this.cart,
    @required this.orders,
  });

  final Cart cart;
  final Orders orders;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  changeLoadingTrue() => _isLoading.value = true;
  changeLoadingFalse() => _isLoading.value = false;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FlatButton(
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                'ORDER NOW',
              ),
        textColor: appThemeData.primaryColor,
        onPressed: (cart.totalAmount <= 0 || isLoading)
            ? null
            : () async {
                changeLoadingTrue();
                await orders.addOrder(
                  cart.items.values.toList(),
                  cart.totalAmount,
                );
                changeLoadingFalse();
                print(cart.items.values.toList());
                cart.clear();
              },
      ),
    );
  }
}
