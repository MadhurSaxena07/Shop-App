import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import '../screen/productdetailscreen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    print("rebuilds");
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                      icon: Icon(product.isfav
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        product.toggleFav(auth.token, auth.userId);
                      },
                      color: Theme.of(context).accentColor,
                    )),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Added item to the cart',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.removeSingle(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor),
          ),
        ));
  }
}
