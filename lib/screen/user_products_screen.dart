import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';
import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/userpscreen';
  Future<void> refreshFn(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getandfetch(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshFn(context),
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: () => snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : refreshFn(context),
          child: Consumer<Products>(
            builder: (context, productsdata, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                        productsdata.items[i].id,
                        productsdata.items[i].title,
                        productsdata.items[i].imageUrl),
                    Divider(),
                  ],
                ),
                itemCount: productsdata.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
