import 'package:improove/redux/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

Store<AppState> createStore() => Store<AppState>(
      appReducer,
      initialState: const AppState.initial(),
      middleware: [
        LoggingMiddleware.printer(),
        thunkMiddleware,
      ],
    );
