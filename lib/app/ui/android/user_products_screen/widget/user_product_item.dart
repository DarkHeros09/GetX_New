import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getx_pattern/app/controller/products/products.dart';
import 'package:getx_pattern/app/ui/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/ui/android/user_products_screen/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({this.id, this.title, this.imageUrl});
  final Products products = Get.put(Products());

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  color: appThemeData.primaryColor,
                  onPressed: () {
                    Get.to(EditProductScreen(), arguments: id);
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: appThemeData.errorColor,
                  onPressed: () {
                    return Get.defaultDialog(
                      title: 'Are You Sure?',
                      radius: 5,
                      content: Text(
                        'Do you want to delete the item from products?',
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              try {
                                products.deletingTrue();
                                Get.back(result: true);
                                await products.deleteProduct(id);
                                products.deletingFalse();
                              } catch (error) {
                                products.deletingFalse();
                                Get.rawSnackbar(
                                  titleText: Text(
                                    'Error',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  messageText: Text(
                                    'Deleting failed!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: appThemeData.primaryColor,
                                  barBlur: 0,
                                );
                              }
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
                  }),
            ],
          ),
        ));
  }
}
