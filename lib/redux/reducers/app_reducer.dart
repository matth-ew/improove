import 'package:improove/redux/models/app_state.dart';
import 'package:improove/redux/reducers/user.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(user: userReducer(state.user, action));
