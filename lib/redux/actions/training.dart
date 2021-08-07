import 'dart:async'; // Add the package
import 'package:flutter/cupertino.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/trainingservice.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetTrainings {
  final Map<int, Training> trainings;

  SetTrainings(this.trainings);
}

class SetTraining {
  final Training training;
  final int id;

  SetTraining(this.training, this.id);
}

ThunkAction<AppState> getTrainingById(int id, [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Training? t = await TrainingService().getTrainingById(id);
      if (t != null) {
        store.dispatch(SetTraining(t, id));
        completer?.complete();
      }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTrainingById " + e.toString());
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> getTraining([Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Map<int, Training>? t = await TrainingService().getTraining();
      if (t != null) {
        store.dispatch(SetTrainings(t));
        completer?.complete();
      }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTraining " + e.toString());
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
