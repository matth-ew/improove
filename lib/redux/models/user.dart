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
  final List<SavedTraining> savedTrainings;
  final List<ClosedTraining> closedTrainings;

  const User({
    required this.name,
    required this.surname,
    required this.profileImage,
    required this.email,
    required this.birth,
    required this.gender,
    this.savedTrainings = const [],
    this.closedTrainings = const [],
  });

  const User.initial()
      : name = "",
        surname = "",
        profileImage = "",
        email = "",
        birth = -1,
        gender = "",
        savedTrainings = const [],
        closedTrainings = const [];

  User copyWith({
    String? name,
    String? surname,
    String? profileImage,
    String? email,
    int? birth,
    String? gender,
    List<SavedTraining>? savedTrainings,
    List<ClosedTraining>? closedTrainings,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      savedTrainings: savedTrainings ?? this.savedTrainings,
      closedTrainings: closedTrainings ?? this.closedTrainings,
    );
  }

  dynamic toJson() => {
        'name': name,
        'surname': surname,
        'profileImage': profileImage,
        'email': email,
        'birth': birth,
        'gender': gender,
        'savedTrainings': savedTrainings,
        'closedTrainings': closedTrainings,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = (json['name'] ?? "") as String,
        surname = (json['surname'] ?? "") as String,
        profileImage = (json['profileImage'] ?? "") as String,
        email = (json['email'] ?? "") as String,
        birth = (json['birth'] ?? -1) as int,
        gender = (json['gender'] ?? "") as String,
        savedTrainings = List<SavedTraining>.from(
            ((json['savedTrainings'] ?? const []) as List)
                .map((t) => SavedTraining.fromJson(t as Map<String, dynamic>))),
        closedTrainings = List<ClosedTraining>.from(((json['closedTrainings'] ??
                const []) as List)
            .map((t) => ClosedTraining.fromJson(t as Map<String, dynamic>)));

  @override
  String toString() {
    return 'User: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}

class SavedTraining {
  final int trainingId;
  final List<String> seenExercises;
  const SavedTraining({
    required this.trainingId,
    required this.seenExercises,
  });

  const SavedTraining.initial()
      : trainingId = -1,
        seenExercises = const [];

  SavedTraining.fromJson(Map<String, dynamic> savedTraining)
      : trainingId = (savedTraining['trainingId'] ?? -1) as int,
        seenExercises =
            (savedTraining['seenExercises'] ?? const []) as List<String>;
}

class ClosedTraining {
  final int trainingId;
  final String challengeUrl;
  const ClosedTraining({
    required this.trainingId,
    required this.challengeUrl,
  });
  const ClosedTraining.initial()
      : trainingId = -1,
        challengeUrl = "";
  ClosedTraining.fromJson(Map<String, dynamic> closedTraining)
      : trainingId = (closedTraining['trainingId'] ?? -1) as int,
        challengeUrl = (closedTraining['challengeUrl'] ?? "") as String;
}
