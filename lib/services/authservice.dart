import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/const/text.dart';

class AuthService {
  Dio dio = Dio();
  Future<Response?> login(String email, String password) async {
    try {
      return await dio.post(
        '$backendUrl/api/authenticate',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
      return e.response;
    }
  }

  Future<Response?> loginFacebook(String accessToken) async {
    try {
      return await dio.post(
        '$backendUrl/api/authenticate-facebook',
        data: {'access_token': accessToken},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("ERRORE" + e.toString());
      return e.response;
    }
  }

  Future<Response?> loginGoogle(String accessToken) async {
    try {
      return await dio.post(
        '$backendUrl/api/authenticate-google',
        data: {'access_token': accessToken},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
      return e.response;
    }
  }

  Future<Response?> loginApple(String authorizationCode) async {
    try {
      return await dio.post(
        '$backendUrl/api/authenticate-apple',
        data: {
          'code': authorizationCode,
          'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        },
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
      return e.response;
    }
  }

  Future<Response?> signup(String email, String password) async {
    try {
      return await dio.post('$backendUrl/api/adduser',
          data: {'email': email, 'password': password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'] as String);
      return e.response;
    }
  }

  Future<Response?> verify(int verifyToken, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/verifyuser',
        data: {'verifyToken': verifyToken},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'] as String);
      return e.response;
    }
  }

  Future<Response?> resendVerification(String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.get('$backendUrl/api/resendverification',
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
      return e.response;
    }
  }

  Future<Response?> token(String refreshToken) async {
    try {
      dio.options.headers['Authorization'] = refreshToken;
      return await dio.get('$backendUrl/api/token',
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
      return e.response;
    }
  }
}
