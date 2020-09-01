import 'package:flutter/material.dart';
import 'package:getx_pattern/app/controller/cart/cart.dart';
import 'package:getx_pattern/app/ui/android/products_overview/widgets/product_details.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../../controller/products/products.dart';

class ProductItem extends StatelessWidget {
  final pIndex;

  ProductItem({
    this.pIndex,
  });

  productDetails() {
    Get.to(
      ProductDetailScreen(),
      arguments: pIndex.id,
      transition: Transition.rightToLeft,
    );
  }

  final Products product = Get.put(Products());
  final Cart cart = Get.put(Cart());
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
          child: GestureDetector(
            onTap: () => productDetails(),
            child: Image.network(
              product.findById(pIndex.id).imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
                icon: GetBuilder(
                  init: product,
                  // id: pIndex.id,
                  builder: (value) {
                    final isFav = product.findById(pIndex.id).isFavorite;
                    return Icon(isFav ? Icons.favorite : Icons.favorite_border);
                  },
                ),
                color: Colors.redAccent,
                onPressed: () {
                  product.toggleFavoriteStatus(pIndex.id);
                }),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: appThemeData.accentColor,
                onPressed: () {
                  cart.addItem(
                      product.findById(pIndex.id).id,
                      product.findById(pIndex.id).price,
                      product.findById(pIndex.id).title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Added ${product.findById(pIndex.id).title} to cart!',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.findById(pIndex.id).id);
                        }),
                  ));
                  // Get.snackbar(
                  //   'Add item to cart!',
                  //   'Item ${product.findById(pIndex.id).title} add to cart',
                  //   snackPosition: SnackPosition.BOTTOM,
                  //   duration: Duration(seconds: 2),
                  // snackStyle: SnackStyle.GROUNDED,);
                }),
            title: Text(
              product.findById(pIndex.id).title,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
