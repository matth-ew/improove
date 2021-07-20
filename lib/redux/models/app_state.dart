// lib/models/app_state.dart
import 'package:meta/meta.dart';
import 'user.dart';

@immutable
class AppState {
  final User user;

  const AppState({
    required this.user,
  });
  const AppState.initial() : user = const User.initial();
}
