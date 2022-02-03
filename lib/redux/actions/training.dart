import 'dart:async'; // Add the package
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/training_service.dart';
import 'package:improove/utility/device_storage.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetTrainings {
  final Map<int, Training> trainings;

  SetTrainings(this.trainings);
}

class SetExploreTrainingsIds {
  final List<int> trainingsIds;

  SetExploreTrainingsIds(this.trainingsIds);
}

class SetNewTrainingsIds {
  final List<int> trainingsIds;

  SetNewTrainingsIds(this.trainingsIds);
}

class SetTraining {
  final Training training;
  final int id;

  SetTraining(this.training, this.id);
}

class SetExercise {
  final Exercise exercise;
  final int trainingId;

  SetExercise(this.exercise, this.trainingId);
}

ThunkAction<AppState> getTrainingById(int id, [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        final Response? r = await TrainingService().getTrainingById(id, token);
        if (r?.data['success'] as bool) {
          final result = r!.data!["result"];
          store.dispatch(
            SetTraining(
              Training.fromJson(result as Map<String, dynamic>),
              id,
            ),
          );
          store.dispatch(SetSubscribed(r.data!["subscribed"] as bool));
          debugPrint("GET TRAININGS BY ID");
        }
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

ThunkAction<AppState> getWeekTraining([Completer? completer]) {
  return (Store<AppState> store) async {
    try {
      final Response? r = await TrainingService().getWeekTraining();
      if (r?.data['success'] as bool) {
        final training = r!.data!["training"];
        final Training t = Training.fromJson(training as Map<String, dynamic>);
        debugPrint("UE DATA ${t.id}");
        store.dispatch(SetTraining(t, t.id));
        store.dispatch(
          SetGeneral(
            store.state.general.copyWith(
              weekTrainingId: t.id,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Errore in getTraining ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> getTrainings(
    [List<int>? ids, int? newest, Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await TrainingService().getTrainings(ids, newest);
      if (r?.data['success'] as bool) {
        // debugPrint("UE GET TRAININGS IN");
        final Map<int, Training> trainings = {};
        final results = [...r!.data!["result"]];
        for (var i = 0; i < results.length; i++) {
          final Training t =
              Training.fromJson(results[i] as Map<String, dynamic>);
          trainings.addAll({t.id: t});
        }
        // store.dispatch(SetTrainings(trainings));

        store.dispatch(SetTrainings(trainings));

        if (ids == null || ids.isEmpty) {
          if (newest != null && newest > 0) {
            store.dispatch(SetNewTrainingsIds(trainings.keys.toList()));
          } else {
            store.dispatch(SetExploreTrainingsIds(trainings.keys.toList()));
          }
          // debugPrint("!all!");
        }
        // debugPrint("action pre-New -> " + store.state.newTrainings.toString());
        // debugPrint("action pre-All -> " + store.state.trainings.toString());
        completer?.complete();
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

ThunkAction<AppState> setTrainingDescription(int id, String text,
    [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        final Response? r =
            await TrainingService().setTrainingDescription(id, text, token);
        if (r?.data['success'] as bool) {
          store.dispatch(SetTraining(
              store.state.trainings[id]!.copyWith(description: text), id));
        }
      }
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

///******************* EXERCISE *******************///

ThunkAction<AppState> setExerciseDescription(int id, String title, String text,
    [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        final Response? r = await TrainingService()
            .setExerciseDescription(id, title, text, token);
        if (r?.data['success'] as bool) {
          final Exercise e = store.state.trainings[id]!.exercises
              .firstWhere((element) => element.title == title)
              .copyWith(description: text);
          store.dispatch(SetExercise(e, id));
        }
      }
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> setExerciseTips(int id, String title, String text,
    [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      // final token = await getAccessToken();
      // if (token != null) {
      //   final Response? r =
      //       await TrainingService().setExerciseTips(id, title, text, token);
      //   if (r?.data['success'] as bool) {
      //     final Exercise e = store.state.trainings[id]!.exercises
      //         .firstWhere((element) => element.title == title)
      //         .copyWith(tips: text);
      //     store.dispatch(SetExercise(e, id));
      //   }
      // }
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> setExerciseMistakes(int id, String title, String text,
    [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      // final token = await getAccessToken();
      // if (token != null) {
      //   final Response? r =
      //       await TrainingService().setExerciseMistakes(id, title, text, token);
      //   if (r?.data['success'] as bool) {
      //     final Exercise e = store.state.trainings[id]!.exercises
      //         .firstWhere((element) => element.title == title)
      //         .copyWith(mistakes: text);
      //     store.dispatch(SetExercise(e, id));
      //   }
      // }
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}

ThunkAction<AppState> setExerciseHow(int id, String title, String text,
    [Completer? completer]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      // final token = await getAccessToken();
      // if (token != null) {
      //   final Response? r =
      //       await TrainingService().setExerciseHow(id, title, text, token);
      //   if (r?.data['success'] as bool) {
      //     final Exercise e = store.state.trainings[id]!.exercises
      //         .firstWhere((element) => element.title == title)
      //         .copyWith(how: text);
      //     store.dispatch(SetExercise(e, id));
      //   }
      // }
    } catch (e) {
      debugPrint("Errore in getTrainerById ${e.toString()}");
      completer?.completeError(e); // Exception thrown, complete with error
    }
  };
}
