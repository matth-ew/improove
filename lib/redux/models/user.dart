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
        image = "assets/images/trainer_avatar.jpg";

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
