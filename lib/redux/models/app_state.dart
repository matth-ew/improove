// lib/models/app_state.dart
import 'package:meta/meta.dart';
import 'models.dart';

@immutable
class AppState {
  final User user;

  //final Training training;
  final Map<int, Training> trainings;

  final Map<int, User> trainers;

  const AppState(
      {required this.user, required this.trainings, required this.trainers});
  const AppState.initial()
      : trainings = const {},
        user = const User.initial(),
        trainers = const {};
}
