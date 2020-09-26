import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/guard_model.dart';

class AuthProviders with ChangeNotifier {
  String _idGuard;
  String _nameGuard;
  String _nokpGuard;
  String _usernameGuard;
  String _passwordGuard;
  DateTime _expiryToken;
  Timer _authTimer;

  GuardModel _authInfo;

  GuardModel get authInfo {
    return _authInfo;
  }

  GuardModel getId(String id) => GuardModel(guardId: token);

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryToken != null &&
        _expiryToken.isAfter(DateTime.now()) &&
        _idGuard != null) {
      return _idGuard;
    }
    return null;
  }

  String get nameGuard {
    return _nameGuard;
  }

  String get usernameGuard {
    return _usernameGuard;
  }

  String get nokpGuard {
    return _nokpGuard;
  }

  Future<void> authenticate(String username, String password) async {
    final Map<String, String> authData = {
      'username': username,
      'password': password
    };

    final response = await http.post(
      'https://flutter.otaiwebsite.com/api/login.php',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['error'] != null) {
      print(responseData);
    } else {
      _idGuard = responseData['guard_id'];
      _nameGuard = responseData['guard_name'];
      _nokpGuard = responseData['guard_nokp'];
      _usernameGuard = responseData['guard_username'];
      _passwordGuard = responseData['guard_password'];
      _expiryToken = DateTime.now().add(
        Duration(
          seconds: 6000,
        ),
      );
    }
    print(_idGuard);
    print(_expiryToken);
    _autoSignout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'guard_id': _idGuard,
        'guard_name': _nameGuard,
        'guard_nokp': _nokpGuard,
        'guard_username': _usernameGuard,
        'guard_password': _passwordGuard,
      },
    );
    print(userData);
    prefs.setString('userData', userData);
    return responseData;
  }

  Future<void> signOut() async {
    _idGuard = null;
    _expiryToken = null;
    _nameGuard = null;
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

    _idGuard = extractedUserData['guard_id'];
    _nameGuard = extractedUserData['guard_name'];
    _nokpGuard = extractedUserData['guard_nokp'];
    _usernameGuard = extractedUserData['guard_username'];
    _passwordGuard = extractedUserData['guard_password'];
    _expiryToken = expiryDate;
    notifyListeners();
    _autoSignout();
    return true;
  }
}
