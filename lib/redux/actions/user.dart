import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/redux/models/models.dart';
import 'package:improove/services/authservice.dart';
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
        cb?.call();
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN ${e.toString()}");
      cb?.call(e);
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
        cb?.call();
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN FACEBOOK ${e.toString()}");
      cb?.call(e);
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
        cb?.call();
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("ERR LOGIN GOOGLE ${e.toString()}");
      cb?.call(e);
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
        cb?.call();
      } else {
        cb?.call(r?.data['msg']);
      }
    } catch (e) {
      debugPrint("UE UAJO ERR O SIGNUP");
      cb?.call(e);
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
      cb?.call();
      //
    } catch (e) {
      cb?.call(e);
    }
  };
}
