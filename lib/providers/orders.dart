import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;

  Orders(this.authToken, this._orders);

  Future<void> addorder(List<CartItem> cartproducts, double amount) async {
    final url =
        'https://flutter-shopapp-92b64.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'datetime': timestamp.toIso8601String(),
          'products': cartproducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: amount,
            products: cartproducts,
            datetime: timestamp));
    notifyListeners();
  }

  Future<void> fetchandset() async {
    final url =
        'https://flutter-shopapp-92b64.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;

    extractedData.forEach((key, orderData) {
      loadedOrders.add(OrderItem(
          id: key,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']);
          }).toList(),
          datetime: DateTime.parse(orderData['datetime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
