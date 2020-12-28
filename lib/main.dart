import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/Cartscreen.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import './screen/product_overview_screen.dart';
import 'package:flutter/material.dart';
import './screen/productdetailscreen.dart';
import 'package:provider/provider.dart';
import './providers/orders.dart';
import './screen/user_products_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (context, auth, previous) =>
                Orders(auth.token, previous == null ? [] : previous.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrangeAccent,
              fontFamily: 'Lato',
              //visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routename: (ctx) => CartScreen(),
              OrdersScreen.routename: (ctx) => OrdersScreen(),
              UserProductScreen.routename: (ctx) => UserProductScreen(),
              EditProductScreen.routename: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
