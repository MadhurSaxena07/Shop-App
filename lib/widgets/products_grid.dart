import 'package:flutter/material.dart';

import './product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfav;
  ProductsGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final loadedproduct = showfav ? productsData.showFav : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedproduct.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: loadedproduct[i],
              //create: (c) => loadedproduct[i],
              child: ProductItem(),
            ));
  }
}
