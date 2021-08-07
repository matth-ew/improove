// lib/models/app_state.dart
import 'package:meta/meta.dart';
import 'models.dart';

@immutable
class AppState {
  final User user;

  //final Training training;
  final Map<int, Training> trainings;

  const AppState({required this.user, required this.trainings});
  const AppState.initial()
      : trainings = const {},
        user = const User.initial();
}
