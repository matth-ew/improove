import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class User {
  final String name;
  final String surname;
  final String profileImage;
  final String email;
  final int birth;
  final String gender;

  const User({
    required this.name,
    required this.surname,
    required this.profileImage,
    required this.email,
    required this.birth,
    required this.gender,
  });

  const User.initial()
      : name = "",
        surname = "",
        profileImage = "",
        email = "",
        birth = -1,
        gender = "";

  User copyWith({
    String? name,
    String? surname,
    String? image,
    String? email,
    int? birth,
    String? gender,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      profileImage: image ?? this.profileImage,
      email: email ?? this.email,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
    );
  }

  dynamic toJson() => {
        'name': name,
        'surname': surname,
        'profileImage': profileImage,
        'email': email,
        'birth': birth,
        'gender': gender,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = (json['name'] ?? "") as String,
        surname = (json['surname'] ?? "") as String,
        profileImage = (json['profileImage'] ?? "") as String,
        email = (json['email'] ?? "") as String,
        birth = (json['birth'] ?? "") as int,
        gender = (json['gender'] ?? "") as String;

  @override
  String toString() {
    return 'User: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}
