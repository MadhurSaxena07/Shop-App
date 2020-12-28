import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isfav = false,
  });

  Future<void> toggleFav(String token, String userId) async {
    bool old = isfav;
    isfav = !isfav;
    notifyListeners();
    final url =
        'https://flutter-shopapp-92b64.firebaseio.com/userFavs/$userId/$id.json?auth=$token';
    try {
      var response = await http.put(url,
          body: json.encode(
            isfav,
          ));
      if (response.statusCode >= 400) {
        isfav = old;
        notifyListeners();
      }
    } catch (error) {
      isfav = old;
      notifyListeners();
    }
  }
}
