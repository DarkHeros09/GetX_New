import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './product_item.dart';
import '../../../../controller/products/products.dart';

class ProductsGrid extends StatelessWidget {
  final Products product = Get.put(Products());
  @override
  Widget build(BuildContext context) {
    return GetX<Products>(
      init: product,
      builder: (data) => GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: data.showOnlyFavorites
              ? data.favoriteItems.length
              : data.items.length,
          itemBuilder: (ctx, index) => ProductItem(
                pIndex: data.showOnlyFavorites
                    ? data.favoriteItems[index]
                    : data.items[index],
              ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          )),
    );
  }
}
