import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:improove/redux/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:improove/redux/models/app_state.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Store<AppState>> createStore() async {
  // Init Persistor for redux_persist
  final persistor = Persistor<AppState>(
    storage: SharedPreferencesEngine("store"), // Or use other engines
    serializer:
        JsonSerializer<AppState>(AppState.fromJson), // Or use other serializers
    throttleDuration: const Duration(seconds: 2),
  );

  // Load initial state
  AppState? initialState;
  try {
    initialState = await persistor.load();
  } catch (e) {
    debugPrint("ERROR $e");
  }

  return Store<AppState>(
    appReducer,
    initialState: initialState ?? const AppState.initial(),
    middleware: [
      LoggingMiddleware.printer(),
      thunkMiddleware,
      persistor.createMiddleware(),
    ],
  );
}

//STORE-ENGINE FOR PERSISTENCE

class SharedPreferencesEngine implements StorageEngine {
  /// Shared preferences key to save to.
  final String key;

  SharedPreferencesEngine([this.key = "app"]);

  @override
  Future<Uint8List?> load() async {
    final sharedPreferences = await _getSharedPreferences();
    //debugPrint("UE LOAD! $key ${sharedPreferences.getString(key)}");
    return stringToUint8List(sharedPreferences.getString(key));
  }

  @override
  Future<void> save(Uint8List? data) async {
    //debugPrint("UE SAVE! $key ${uint8ListToString(data)}");
    final sharedPreferences = await _getSharedPreferences();
    if (data != null) {
      sharedPreferences.setString(key, uint8ListToString(data)!);
    }
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    return SharedPreferences.getInstance();
  }
}
