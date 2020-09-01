import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/products/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Products data = Get.put(Products());
  @override
  Widget build(BuildContext context) {
    final pid = Get.arguments;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(data.findById(pid).title),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      data.findById(pid).imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\$${data.findById(pid).price}',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      data.findById(pid).description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            )));
  }
}
