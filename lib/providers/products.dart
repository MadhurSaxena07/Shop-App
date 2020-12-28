import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFav {
    return _items.where((element) => element.isfav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  /*Future<void> addProduct(Product p) {
    //_items.add(value);
    const url = 'https://flutter-shopapp-92b64.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        'title': p.title,
        'description': p.description,
        'price': p.price,
        'imageUrl': p.imageUrl,
        'isfav': p.isfav
      }),
    )
        .then((value) {
      print(json.decode(value.body));

      final newp = Product(
          id: json.decode(value.body)['name'],
          title: p.title,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl);
      _items.add(newp);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error; // cause we want to handle it in the edit product scrn
    });
  }*/

  Future<void> addProduct(Product p) async {
    //_items.add(value);
    final url =
        'https://flutter-shopapp-92b64.firebaseio.com/products.json?auth=$authToken';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'price': p.price,
          'imageUrl': p.imageUrl,
          'creatorId': userId,
        }),
      );

      print(json.decode(value.body));

      final newp = Product(
          id: json.decode(value.body)['name'],
          title: p.title,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl);
      _items.add(newp);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; // cause we want to handle it in the edit product scrn
    }
  }

  Future<void> getandfetch([bool filterbyUser = false]) async {
    final filterString =
        filterbyUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shopapp-92b64.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(url);
      final extactedData = json.decode(response.body) as Map<String, dynamic>;
      if (extactedData == null) return;

      url =
          'https://flutter-shopapp-92b64.firebaseio.com/userFavs/$userId.json?auth=$authToken';
      final favresponse = await http.get(url);
      final favdata = json.decode(favresponse.body);
      final List<Product> loadedp = [];
      extactedData.forEach((prodId, value) {
        loadedp.add(Product(
          id: prodId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isfav: favdata == null || favdata[prodId] == null
              ? false
              : favdata[prodId],
        ));
      });
      _items = loadedp;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateP(String id, Product newP) async {
    int idx = _items.indexWhere((element) => element.id == id);
    if (idx >= 0) {
      final url =
          'https://flutter-shopapp-92b64.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newP.title,
            'description': newP.description,
            'price': newP.price,
            'imageUrl': newP.imageUrl,
          }));
      _items[idx] = newP;
      notifyListeners();
    }
  }

  Future<void> deleteP(String id) async {
    final url =
        'https://flutter-shopapp-92b64.firebaseio.com/products/$id.json?auth=$authToken';
    final existingId = _items.indexWhere((element) => element.id == id);
    var existingP = _items[existingId];
    _items.removeAt(existingId);
    notifyListeners();

    var value = await http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(existingId, existingP);
      notifyListeners();
      throw HttpException('throw error');
    }

    existingP = null;
  }
}
