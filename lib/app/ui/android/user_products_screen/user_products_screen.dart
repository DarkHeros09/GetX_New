import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/ui/android/products_overview/widgets/app_drawer.dart';
import 'package:getx_pattern/app/ui/android/user_products_screen/edit_products_screen.dart';

import '../../../controller/products/products.dart';
import '../../android/user_products_screen/widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  final Products product = Get.put(Products());

  Future<void> _refreshProducts() async {
    await product.fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Get.to(EditProductScreen());
                })
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshProducts,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: GetBuilder<Products>(
                          init: product,
                          builder: (ctx) => product.isDeleting
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount: product.items.length,
                                  itemBuilder: (_, i) => Column(
                                    children: [
                                      UserProductItem(
                                        id: product.items[i].id,
                                        title: product.items[i].title,
                                        imageUrl: product.items[i].imageUrl,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
