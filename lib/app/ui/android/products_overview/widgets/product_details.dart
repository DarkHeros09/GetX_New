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
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(data.findById(pid).title),
                    background: Hero(
                      tag: pid,
                      child: Image.network(
                        data.findById(pid).imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\$${data.findById(pid).price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
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
                ]))
              ],
            )));
  }
}
