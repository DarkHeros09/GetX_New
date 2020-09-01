import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/ui/android/products_overview/widgets/app_drawer.dart';

import '../../../controller/cart/orders.dart' show Orders;
import '../orders_screen/widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  final Orders orderData = Get.put(Orders());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Your Orders'),
          ),
          drawer: AppDrawer(),
          body: FutureBuilder(
            future: orderData.fetchOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error occurred!'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) => OrderItem(
                      order: orderData.orders[index],
                    ),
                  );
                }
              }
            },
          )),
    );
  }
}
