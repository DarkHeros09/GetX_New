import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controller/cart/cart.dart';
import '../../../../app/controller/products/products.dart';
import '../../../../app/ui/android/cart_screen/cart_screen.dart';
import '../../../../app/ui/android/products_overview/widgets/app_drawer.dart';

import './widgets/products_grid.dart';
import './widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatelessWidget {
  final Products product = Get.put(Products());

  final Cart cart = Get.put(Cart());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'MyShop',
          ),
          actions: [
            GetBuilder<Products>(
              init: product,
              builder: (ctx) => PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: (FilterOptions selected) {
                    if (selected == FilterOptions.Favorites) {
                      ctx.fav();
                    } else {
                      ctx.all();
                    }
                  },
                  itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.Favorites,
                        ),
                        PopupMenuItem(
                          child: Text('Show All'),
                          value: FilterOptions.All,
                        )
                      ]),
            ),
            GetBuilder<Cart>(
              init: cart,
              builder: (ctx) => Badge(
                child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Get.to(CartScreen());
                    }),
                value: ctx.itemCount.toString(),
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: product.fetchProducts(),
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
                return ProductsGrid();
              }
            }
          },
        ),
      ),
    );
  }
}
