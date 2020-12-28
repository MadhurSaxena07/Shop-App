import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/ordersc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchandset(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An error Occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderdata, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItem(orderdata.orders[i]),
                    itemCount: orderdata.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
