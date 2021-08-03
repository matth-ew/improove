import 'dart:async'; // Add the package
import 'package:flutter/foundation.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/trainingservice.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetTraining {
  final Training training;

  SetTraining(this.training);
}

ThunkAction<AppState> getTraining([Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Training? t = await TrainingService().getTraining();
      if (t != null) {
        debugPrint("UE UAJO SET O TRAINING");
        store.dispatch(SetTraining(t));
        completer?.complete();
      }
      // No exception, complete without error
    } catch (e) {
      debugPrint("UE UAJO ERR O TRAINING");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
