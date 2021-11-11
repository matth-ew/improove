// lib/models/app_state.dart
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'models.dart';

@immutable
class AppState {
  final User user;

  //final Training training;
  final Map<int, Training> trainings;
  final List<int> exploreTrainingsIds;
  final List<int> newTrainingsIds;
  final Map<int, User> trainers;

  const AppState({
    required this.user,
    required this.trainings,
    required this.exploreTrainingsIds,
    required this.newTrainingsIds,
    required this.trainers,
  });
  const AppState.initial()
      : trainings = const {},
        exploreTrainingsIds = const [],
        newTrainingsIds = const [],
        user = const User.initial(),
        trainers = const {};

  dynamic toJson() => {
        'user': user.toJson(),
        //'trainers': trainers.entries.map((e) => {e.key: e.value.toJson()}),
        //'trainings': trainings.entries.map((e) => {e.key: e.value.toJson()}),
      };
  static AppState fromJson(dynamic json) {
    if (json == null) return const AppState.initial();
    return AppState(
      user: User.fromJson(json['user']),
      trainers: const {},
      trainings: const {},
      exploreTrainingsIds: const [],
      newTrainingsIds: const [],
      /*trainers: (json['trainers'] ?? "").map(
        (t) => {
          t["key"]: User.fromJson(
            t["value"],
          ),
        },
      ) as Map<int, User>,
      trainings: (json['trainings'] ?? "").map(
        (t) => {
          t["key"]: Training.fromJson(
            t["value"],
          ),
        },
      ) as Map<int, Training>,*/
    );
  }
  /*
      : user = User.fromJson(json['user']),
        trainers = (json['trainers'] ?? "")
                .map((t) => {t["key"]: User.fromJson(t["value"])})
            as Map<int, User>,
        trainings = (json['trainings'] ?? "")
                .map((t) => {t["key"]: Training.fromJson(t["value"])})
            as Map<int, Training>;
            */
}
