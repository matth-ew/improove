import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class User {
  final String name;
  final String surname;

  const User({required this.name, required this.surname});

  const User.initial()
      : name = "",
        surname = "";

  User copyWith({String? name, String? surname}) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
    );
  }

  dynamic toJson() => {
        'name': name,
        'surname': surname,
      };

  @override
  String toString() {
    return 'User: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
