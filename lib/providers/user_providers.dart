import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProviders with ChangeNotifier {
  String _id;
  String _name;
  String _username;
  String _password;
  DateTime _expiryToken;
  Timer _authTimer;

  UserModel _authInfo;

  UserModel get authInfo {
    return _authInfo;
  }

  UserModel getId(String id) => UserModel(id: token);

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryToken != null &&
        _expiryToken.isAfter(DateTime.now()) &&
        _id != null) {
      return _id;
    }
    return null;
  }

  String get name {
    return _name;
  }

  String get username {
    return _username;
  }

  Future<void> authenticate(String username, String password) async {
    final Map<String, String> authData = {
      'username': username,
      'password': password
    };

    final response = await http.post(
      new Uri.http("10.0.2.2", "api/login.php"),
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['error'] != null) {
      print(responseData);
    } else {
      _id = responseData['id'];
      _name = responseData['name'];
      _username = responseData['username'];
      _password = responseData['password'];
      _expiryToken = DateTime.now().add(
        Duration(
          seconds: 6000,
        ),
      );
    }
    print(_id);
    print(_expiryToken);
    _autoSignout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'id': _id,
        'name': _name,
        'username': _username,
        'password': _password,
      },
    );
    print(userData);
    prefs.setString('userData', userData);
    return responseData;
  }

  Future<void> signOut() async {
    _id = null;
    _expiryToken = null;
    _name = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoSignout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryToken.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }

  Future<bool> tryAutoSignin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.now().subtract(
      Duration(
        seconds: 5000,
      ),
    );

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _id = extractedUserData['id'];
    _name = extractedUserData['name'];
    _username = extractedUserData['username'];
    _password = extractedUserData['password'];
    _expiryToken = expiryDate;
    notifyListeners();
    _autoSignout();
    return true;
  }
}
