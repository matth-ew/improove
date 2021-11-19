import 'package:improove/redux/models/models.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AddLocalVideo {
  final LocalVideo video;

  AddLocalVideo(this.video);
}

ThunkAction<AppState> addLocalVideoThunk(LocalVideo video, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(AddLocalVideo(video));
      cb?.call(null);
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

// class SetTrainer {
//   final User trainer;
//   final int id;

//   SetTrainer(this.trainer, this.id);
// }

// ThunkAction<AppState> getTrainerById(int id, [Completer? completer]) {
//   // Define the parameter
//   return (Store<AppState> store) async {
//     try {
//       final Response? r = await TrainerService().getTrainerById(id);
//       if (r?.data['success'] as bool) {
//         final results = [...r!.data!['trainings']];
//         final User u =
//             User.fromJson(r.data!['trainer'] as Map<String, dynamic>);
//         for (var i = 0; i < results.length; i++) {
//           results[i]["trainer_id"] = id;
//           results[i]["trainer_image"] = u.profileImage;
//           final Training t =
//               Training.fromJsonUnpopulated(results[i] as Map<String, dynamic>);
//           if (store.state.trainings[t.id]?.title != "") {
//             store.dispatch(SetTraining(t, t.id));
//           }
//         }

//         store.dispatch(SetTrainer(u, u.id));
//       }

//       // if (t != null) {
//       //   store.dispatch(SetTrainer(t, id));
//       //   completer?.complete();
//       // }
//       // No exception, complete without error
//     } catch (e) {
//       debugPrint("Errore in getTrainerById ${e.toString()}");
//       completer?.completeError(e); // Exception thrown, complete with error
//     }
//   };
// }

// ThunkAction<AppState> setTrainerDescription(int id, String text,
//     [Completer? completer]) {
//   // Define the parameter
//   return (Store<AppState> store) async {
//     try {
//       final token = await getAccessToken();
//       if (token != null) {
//         final Response? r =
//             await TrainerService().setTrainerDescription(id, text, token);
//         if (r?.data['success'] as bool) {
//           store.dispatch(SetTrainer(
//               store.state.trainers[id]!.copyWith(trainerDescription: text),
//               id));
//         }
//       }
//     } catch (e) {
//       debugPrint("Errore in getTrainerById ${e.toString()}");
//       completer?.completeError(e); // Exception thrown, complete with error
//     }
//   };
// }

// ThunkAction<AppState> setTrainerImage(File image, int id,
//     [Completer? completer]) {
//   return (Store<AppState> store) async {
//     try {
//       final token = await getAccessToken();
//       if (token != null) {
//         final Response? r =
//             await TrainerService().setTrainerImage(image, token);
//         if (r?.data['success'] as bool) {
//           //debugPrint("UE RESP ${r?.data}");
//           final String image = r!.data!["image"] as String;
//           store.dispatch(SetTrainer(
//               store.state.trainers[id]!.copyWith(trainerImage: image), id));
//           store.dispatch(SetTrainerImage(image));
//         }
//       }
//       //
//     } catch (e) {
//       completer?.completeError(e);
//     }
//   };
// }
