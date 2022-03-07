import 'dart:async'; // Add the package
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/training_service.dart';
import 'package:improove/utility/device_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SetInCreationTraining {
  final Training training;

  SetInCreationTraining(this.training);
}

class AddICTExercise {
  final Exercise exercise;

  AddICTExercise(this.exercise);
}

class RemoveICTExercise {
  final String id;

  RemoveICTExercise(this.id);
}

class ReorderICTExercise {
  final int oldIndex;
  final int newIndex;

  ReorderICTExercise(this.oldIndex, this.newIndex);
}

class ICTReset {
  ICTReset();
}

class UrlTrain {
  final String url;
  final String file;
  final String key;
  const UrlTrain({
    required this.url,
    required this.file,
    required this.key,
  });

  UrlTrain.fromJson(Map<String, dynamic> json)
      : url = (json['url']) as String,
        key = (json['key']) as String,
        file = (json['file']) as String;
}

ThunkAction<AppState> uploadTrainingThunk([Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        var ict = store.state.inCreationTraining;
        Training t = ict.copyWith(
          exercises: ict.exercises.map((e) {
            return e.copyWith(
              video: basename(e.video),
              preview: basename(e.preview),
            );
          }).toList(),
        );
        final Response? r = await TrainingService().createTraining(t, token);
        if (r?.data['success'] as bool) {
          debugPrint(r!.data!["urls"].toString());
          final urls = [...r.data!["urls"]];
          Future.forEach(urls, (item) async {
            var castedItem = UrlTrain.fromJson(item as Map<String, dynamic>);
            var split = castedItem.file.split(".");
            var type = "";
            String path = "";
            if (split[split.length - 1] == "mp4") {
              type = "video/mp4";
              path = ict.exercises.map((e) => e.video).firstWhere(
                  (v) => basename(v) == castedItem.file,
                  orElse: () => "");
            } else {
              path = ict.exercises.map((e) => e.preview).firstWhere(
                  (v) => basename(v) == castedItem.file,
                  orElse: () => "");
              type = "image/webp";
            }

            if (path.isNotEmpty) {
              var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
              var newPath =
                  path.substring(0, lastSeparator + 1) + castedItem.key;
              var file = File(path).renameSync(newPath);
              await TrainingService().uploadObject(file, castedItem.url, type);
            }
          }).then((value) async {
            /* QUI CANCELLO LA ROBA */
            // final file =
            //     File(store.state.inCreationTraining.exercises[0].video);
            // var dir = file.parent;
            // debugPrint("UE DIR $dir ${dir.listSync().toString()}");
            // dir.deleteSync(recursive: true);

            var dir = await getApplicationDocumentsDirectory();
            dir = Directory(
                "${dir.path}${Platform.pathSeparator}inCreationTraining");
            dir.deleteSync(recursive: true);
            dir.create();

            dir = await getTemporaryDirectory();
            dir.deleteSync(recursive: true);
            dir.create();

            store.dispatch(ICTReset());
            cb?.call(null);
          }).catchError((e) {
            cb?.call(e.toString());
          });

          // final User u =
          //     User.fromJson(r!.data!["user"] as Map<String, dynamic>);
          // store.dispatch(SetUser(u));
          // await faSetUser(u);
          // await setAccessToken(r.data!["token"] as String);
          // cb?.call(null);
        } else {
          cb?.call(r?.data['msg']);
        }
      }
    } catch (e) {
      debugPrint("ERR UPLOAD ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}
