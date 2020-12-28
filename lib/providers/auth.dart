import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
      String email, String password, String urlaction) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlaction?key=AIzaSyBi2L5RYhLle9cyJsSUJQJQ2G0NsOgpjBQ';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final rdata = json.decode(response.body);
      if (rdata['error'] != null) {
        throw HttpException(rdata['error']['message']);
      }
      _token = rdata['idToken'];
      _userId = rdata['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(rdata['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
