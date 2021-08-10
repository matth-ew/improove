import 'dart:async'; // Add the package
import 'package:dio/dio.dart';
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
      final Response? r = await TrainerService().getTrainerById(id);
      if (r?.data['success'] as bool) {
        final User u =
            User.fromJson(r!.data!["trainer"] as Map<String, dynamic>);

        store.dispatch(SetTrainer(u, u.id));
      }

      // if (t != null) {
      //   store.dispatch(SetTrainer(t, id));
      //   completer?.complete();
      // }
      // No exception, complete without error
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
