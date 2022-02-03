import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class User {
  final int id;
  final String name;
  final String surname;
  final String referral;
  final bool subscribed;
  final String? profileImage;
  final String? trainerImage;
  final String email;
  final int birth;
  final String gender;
  final String trainerDescription;
  final List<SavedTraining> savedTrainings;
  final List<ClosedTraining> closedTrainings;

  const User({
    required this.name,
    required this.surname,
    this.referral = "",
    this.subscribed = false,
    this.profileImage,
    this.trainerImage,
    required this.email,
    required this.birth,
    required this.gender,
    required this.id,
    required this.trainerDescription,
    this.savedTrainings = const [],
    this.closedTrainings = const [],
  });

  const User.initial()
      : name = "",
        surname = "",
        referral = "",
        subscribed = false,
        profileImage = null,
        trainerImage = "",
        email = "",
        birth = -1,
        gender = "",
        id = -1,
        trainerDescription = "",
        savedTrainings = const [],
        closedTrainings = const [];

  User copyWith({
    String? name,
    String? surname,
    String? referral,
    bool? subscribed,
    String? profileImage,
    String? trainerImage,
    String? email,
    int? birth,
    String? gender,
    int? id,
    String? trainerDescription,
    List<SavedTraining>? savedTrainings,
    List<ClosedTraining>? closedTrainings,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      referral: referral ?? this.referral,
      subscribed: subscribed ?? this.subscribed,
      profileImage: profileImage ?? this.profileImage,
      trainerImage: trainerImage ?? this.trainerImage,
      email: email ?? this.email,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      trainerDescription: trainerDescription ?? this.trainerDescription,
      savedTrainings: savedTrainings ?? this.savedTrainings,
      closedTrainings: closedTrainings ?? this.closedTrainings,
    );
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'referral': referral,
        'subscribed': subscribed,
        'profileImage': profileImage,
        'trainerImage': trainerImage,
        'email': email,
        'birth': birth,
        'gender': gender,
        'trainer description': trainerDescription,
        'savedTrainings': savedTrainings,
        'closedTrainings': closedTrainings,
      };

  User.fromJson(dynamic json)
      : name = (json['name'] ?? "") as String,
        surname = (json['surname'] ?? "") as String,
        referral = (json['referral'] ?? "") as String,
        subscribed = (json['subscribed'] ?? false) as bool,
        profileImage = (json['profileImage'] ?? "") as String,
        trainerImage = (json['trainerImage'] ?? "") as String,
        email = (json['email'] ?? "") as String,
        birth = (json['birth'] ?? -1) as int,
        gender = (json['gender'] ?? "") as String,
        id = (json['_id'] ?? -1) as int,
        trainerDescription = (json['trainerDescription'] ?? "") as String,
        savedTrainings = List<SavedTraining>.from(
            ((json['savedTrainings'] ?? const []) as List)
                .map((t) => SavedTraining.fromJson(t as Map<String, dynamic>))),
        // savedTrainings = <SavedTraining>[
        //   ...[
        //     SavedTraining(
        //         trainingId: json['savedTrainings'][0]["trainingId"] as int,
        //         seenExercises: (json['savedTrainings'][0]["seenExercises"] ??
        //             <String>[]) as List<String>)
        //   ]
        // ],
        closedTrainings = List<ClosedTraining>.from(((json['closedTrainings'] ??
                const []) as List)
            .map((t) => ClosedTraining.fromJson(t as Map<String, dynamic>)));

  @override
  String toString() {
    return 'User: ${const JsonEncoder.withIndent('  ').convert(this)}';
  }
}

@immutable
class SavedTraining {
  final int trainingId;
  final List<String> seenExercises;
  const SavedTraining({
    required this.trainingId,
    required this.seenExercises,
  });

  dynamic toJson() => {
        'trainingId': trainingId,
        'seenExercises': seenExercises,
      };

  const SavedTraining.initial()
      : trainingId = -1,
        seenExercises = const <String>[];

  SavedTraining.fromJson(Map<String, dynamic> json)
      : trainingId = (json['trainingId'] ?? -1) as int,
        seenExercises = (const <String>[]);
}

@immutable
class ClosedTraining {
  final int trainingId;
  final String challengeUrl;
  const ClosedTraining({
    required this.trainingId,
    required this.challengeUrl,
  });

  dynamic toJson() => {
        'trainingId': trainingId,
        'challengeUrl': challengeUrl,
      };
  const ClosedTraining.initial()
      : trainingId = -1,
        challengeUrl = "";
  ClosedTraining.fromJson(Map<String, dynamic> closedTraining)
      : trainingId = (closedTraining['trainingId'] ?? -1) as int,
        challengeUrl = (closedTraining['challengeUrl'] ?? "") as String;
}
