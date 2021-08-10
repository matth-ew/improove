import 'dart:async'; // Add the package
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      final Response? r = await TrainingService().getTrainingById(id);
      if (r?.data['success'] as bool) {
        final result = r!.data!["result"];
        store.dispatch(
          SetTraining(
            Training.fromJson(result as Map<String, dynamic>),
            id,
          ),
        );
      }
      // final Training training = Training.fromJson(res.data!);
      // if (t != null) {
      //   store.dispatch(SetTraining(t, id));
      //   completer?.complete();
      // }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTrainingById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> getTrainings([Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await TrainingService().getTrainings();
      if (r?.data['success'] as bool) {
        // debugPrint("UE GET TRAININGS IN");
        final Map<int, Training> trainings = {};
        final results = [...r!.data!["result"]];
        for (var i = 0; i < results.length; i++) {
          final Training t =
              Training.fromJson(results[i] as Map<String, dynamic>);
          // debugPrint("INDEX $i ${t.toString()}");
          trainings.addAll({t.id: t});
        }
        // debugPrint("TRAININGS $trainings");
        store.dispatch(SetTrainings(trainings));
        // if (t != null) {
        //   store.dispatch(SetTrainings(t));
        //   completer?.complete();
        // }
      }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTraining ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
