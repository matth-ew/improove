import 'dart:async'; // Add the package
import 'package:flutter/foundation.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/trainer_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetTrainer {
  final User trainer;
  final int id;

  SetTrainer(this.trainer, this.id);
}

ThunkAction<AppState> getTrainerById(int id, [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final User? t = await TrainerService().getTrainerById(id);
      if (t != null) {
        store.dispatch(SetTrainer(t, id));
        completer?.complete();
      }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTrainingById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
