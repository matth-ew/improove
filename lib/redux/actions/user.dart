import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/redux/actions/actions.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/authservice.dart';
import 'package:improove/services/user_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class SetUser {
  final User user;

  SetUser(this.user);
}

class SetFullName {
  final String name;
  final String surname;

  SetFullName(this.name, this.surname);
}

class SetProfileImage {
  final String profileImage;

  SetProfileImage(this.profileImage);
}

class SetTrainerImage {
  final String trainerImage;

  SetTrainerImage(this.trainerImage);
}

class AddSavedTraining {
  final SavedTraining savedTraining;

  AddSavedTraining(this.savedTraining);
}

class DeleteSavedTraining {
  final int trainingId;

  DeleteSavedTraining(this.trainingId);
}

class UserLogout {
  UserLogout();
}

ThunkAction<AppState> loginThunk(String email, String password,
    [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await AuthService().login(email, password);
      if (r?.data['success'] as bool) {
        final User u = User.fromJson(r!.data!["user"] as Map<String, dynamic>);
        store.dispatch(SetUser(u));
        await storage.write(
            key: "accessToken", value: r.data!["token"] as String);
        cb?.call(null);
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> loginFacebookThunk(String accessToken, [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await AuthService().loginFacebook(accessToken);
      if (r?.data['success'] as bool) {
        // debugPrint(r!.data!["user"].toString());
        final User u = User.fromJson(r!.data!["user"] as Map<String, dynamic>);
        store.dispatch(SetUser(u));
        await storage.write(
            key: "accessToken", value: r.data!["token"] as String);
        cb?.call(null);
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN FACEBOOK ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> loginGoogleThunk(String accessToken, [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await AuthService().loginGoogle(accessToken);
      if (r?.data['success'] as bool) {
        final User u = User.fromJson(r!.data!["user"] as Map<String, dynamic>);
        store.dispatch(SetUser(u));
        await storage.write(
            key: "accessToken", value: r.data!["token"] as String);
        cb?.call(null);
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN GOOGLE ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> loginAppleThunk(String authorizationCode,
    [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await AuthService().loginApple(authorizationCode);
      if (r?.data['success'] as bool) {
        final User u = User.fromJson(r!.data!["user"] as Map<String, dynamic>);
        store.dispatch(SetUser(u));
        await storage.write(
            key: "accessToken", value: r.data!["token"] as String);
        cb?.call(null);
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN APPLE ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> signupThunk(String email, String password,
    [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final Response? r = await AuthService().signup(email, password);
      if (r?.data['success'] as bool) {
        final User u = User.fromJson(r!.data!["user"] as Map<String, dynamic>);
        store.dispatch(SetUser(u)); // Create storage
        await storage.write(
            key: "accessToken", value: r.data!["token"] as String);
        cb?.call(null);
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("UE UAJO ERR O SIGNUP $e");
      cb?.call(e.toString());
    }
  };
}
//String accessToken = await storage.read(key: "accessToken");

ThunkAction<AppState> logoutThunk([Function? cb]) {
  return (Store<AppState> store) async {
    try {
      await storage.delete(key: "accessToken");
      //CANCELLA DATI DA REDUX!
      store.dispatch(UserLogout());
      cb?.call(null);
      //
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> changeProfileImageThunk(File image, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        final Response? r =
            await UserService().changeProfileImage(image, token);
        if (r?.data['success'] as bool) {
          //debugPrint("UE RESP ${r?.data}");
          final String image = r!.data!["image"] as String;
          store.dispatch(SetProfileImage(image));
        }
        cb?.call(null);
      }
      //
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> changeProfileInfoThunk(String name, String surname,
    [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        final Response? r = await UserService().changeProfileInfo(
          name,
          surname,
          token,
        );
        if (r?.data['success'] as bool) {
          store.dispatch(SetFullName(name, surname));
        }
        cb?.call(null);
      }
      //
    } catch (e) {
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> getInfoThunk([Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        final Response? r = await UserService().getInfo(token);
        //debugPrint("UE RESP ${r?.data}");
        if (r?.data['success'] as bool) {
          final User u =
              User.fromJson(r!.data!["user"] as Map<String, dynamic>);
          //debugPrint("UE USER ${u.toString()}");
          store.dispatch(SetUser(u));
          if (u.savedTrainings.isNotEmpty || u.closedTrainings.isNotEmpty) {
            final List<int> ids = {
              ...u.savedTrainings.map((s) => s.trainingId),
              ...u.closedTrainings.map((c) => c.trainingId),
            }.toList();
            store.dispatch(getTrainings(ids));
          }
        }
      }
    } catch (e) {
      debugPrint("UE ERR GETINFO $e");
      cb?.call(e);
    }
  };
}

ThunkAction<AppState> setExerciseCompleted(int trainingId, String exerciseId,
    [Function? cb]) {
  // Define the parameter
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        // final Response? r =
        //     await TrainingService().setExerciseMistakes(id, title, text, token);
        // if (r?.data['success'] as bool) {
        //   final Exercise e = store.state.trainings[id]!.exercises
        //       .firstWhere((element) => element.title == title)
        //       .copyWith(mistakes: text);
        //   store.dispatch(SetExercise(e, id));
        // }
        cb?.call(null);
      }
    } catch (e) {
      debugPrint("Errore in setExercise ${e.toString()}");
      cb?.call(e.toString());
    }
  };
}

ThunkAction<AppState> saveTrainingThunk(int trainingId, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        final Response? r = await UserService().saveTraining(trainingId, token);
        //debugPrint("UE RESP $r");
        if (r?.data['success'] as bool) {
          final SavedTraining s =
              SavedTraining(trainingId: trainingId, seenExercises: const []);
          store.dispatch(AddSavedTraining(s));
          // final User u =
          //     User.fromJson(r!.data!["user"] as Map<String, dynamic>);
          // debugPrint("UE USER ${u.toString()}");
          // store.dispatch(SetUser(u));
        }
      }
    } catch (e) {
      cb?.call(e);
    }
  };
}

ThunkAction<AppState> removeTrainingThunk(int trainingId, [Function? cb]) {
  return (Store<AppState> store) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        final Response? r =
            await UserService().removeTraining(trainingId, token);
        if (r?.data['success'] as bool) {
          store.dispatch(DeleteSavedTraining(trainingId));
          // final User u =
          //     User.fromJson(r!.data!["user"] as Map<String, dynamic>);
          // debugPrint("UE USER ${u.toString()}");
          // store.dispatch(SetUser(u));
        }
      }
    } catch (e) {
      cb?.call(e);
    }
  };
}
