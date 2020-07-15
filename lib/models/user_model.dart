import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  final String id;
  final String name;
  final String username;
  final String password;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.password,
  });
}