// lib/models/app_state.dart
import 'package:meta/meta.dart';
import 'models.dart';

@immutable
class AppState {
  final User user;

  final Training training;

  const AppState({required this.training, required this.user});
  const AppState.initial()
      : training = const Training.initial(),
        user = const User.initial();
}
