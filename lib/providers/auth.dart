import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token = null;
  DateTime? _expiryDate = null;
  String? _userId = null;

  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      {
        return _token;
      }
    }
    return null;
  }
  //Authenticate helper function for signup and signin

  Future<void> _authenticate(
      String email, String password, String authType) async {
    final url = Uri.https(
        "identitytoolkit.googleapis.com",
        "/v1/accounts:$authType",
        {"key": "AIzaSyBuMLdhUwzbsGegMXQcN7aL58_qzjWWB9I"});

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              "email": email,
              "password": password,
              'returnSecureToken': true,
            },
          ));
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  //User Signup
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  //User Sign In

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
