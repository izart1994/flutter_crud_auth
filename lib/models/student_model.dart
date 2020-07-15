import 'package:flutter/foundation.dart';

class StudentModel with ChangeNotifier {
  final String id;
  final String name;
  final String age;

  StudentModel({
    this.id,
    this.name,
    this.age,
  });
}
