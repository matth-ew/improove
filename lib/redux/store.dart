import 'package:improove/redux/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/models/app_state.dart';
//import 'package:redux_logging/redux_logging.dart';

Store<AppState> createStore() => Store<AppState>(
      appReducer,
      initialState: const AppState.initial(),
      // middleware: [new LoggingMiddleware.printer()],
    );
