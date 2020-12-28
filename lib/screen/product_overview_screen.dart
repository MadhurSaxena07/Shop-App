import 'package:flutter/material.dart';
import 'package:shop_app/screen/Cartscreen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum Filteroption {
  Favourite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showonlyFav = false;
  var _isinit = true;
  var _isloading = false;

  @override
  void initState() {
    //Provider.of<Products>(context, listen: false).getandfetch();
    //Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).getandfetch();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Products>(context).getandfetch().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (Filteroption sval) {
                setState(() {
                  if (sval == Filteroption.Favourite) {
                    _showonlyFav = true;
                  } else {
                    _showonlyFav = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text("Favourites"), value: Filteroption.Favourite),
                PopupMenuItem(child: Text('Show All'), value: Filteroption.All)
              ],
              icon: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemcount.toString()),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routename);
                  }),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showonlyFav));
  }
}
