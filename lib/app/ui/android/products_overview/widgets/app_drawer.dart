import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/auth/auth.dart';
import 'package:getx_pattern/app/ui/android/orders_screen/orders_screen.dart';
import 'package:getx_pattern/app/ui/android/user_products_screen/user_products_screen.dart';
import '../products_overview.dart';

class AppDrawer extends StatelessWidget {
  final Auth auth = Get.put(Auth());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Get.back();
                Get.off(ProductsOverviewScreen());
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Your Orders'),
              onTap: () {
                Get.back();
                Get.to(OrdersScreen());
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Get.back();
                Get.to(UserProductsScreen());
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Get.back();
                auth.logout();
              }),
          Divider(),
        ],
      ),
    );
  }
}
