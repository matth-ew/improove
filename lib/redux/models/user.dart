import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class User {
  final String name;
  final String surname;
  final String image;

  const User({required this.name, required this.surname, required this.image});

  const User.initial()
      : name = "prova",
        surname = "prova",
        image =
            "https://images.unsplash.com/photo-1619361728853-2542f3864532?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";

  User copyWith({String? name, String? surname, String? image}) {
    return User(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        image: image ?? this.image);
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
