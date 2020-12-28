import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(18),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.tamount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, i) => CartItem(
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].id,
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity,
                      cart.items.values.toList()[i].title),
                  itemCount: cart.itemcount))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.tamount <= 0 || isloading)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).addorder(
                  widget.cart.items.values.toList(), widget.cart.tamount);
              widget.cart.clear();
              setState(() {
                isloading = false;
              });
            },
      child: isloading
          ? CircularProgressIndicator()
          : Text(
              'ORDER!',
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
