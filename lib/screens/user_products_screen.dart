import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => UserProductItem(
            title: productsData.items[i].title,
            imageUrl: productsData.items[i].imageUrl,
          ),
        ),
      ),
    );
  }
}
