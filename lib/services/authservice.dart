import 'dart:io';
import 'package:dio/dio.dart';

const backendUrl = 'http://10.0.2.2:3001';

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
      print(e.response?.data['msg']);
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
      print("ERRORE" + e.toString());
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
      print(e.response?.data['msg']);
      return e.response;
    }
  }

  Future<Response?> loginApple(String accessToken) async {
    try {
      return await dio.post(
        '$backendUrl/api/authenticate-apple',
        data: {'access_token': accessToken},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return e.response;
    }
  }

  Future<Response?> signup(String email, String password) async {
    try {
      return await dio.post('$backendUrl/api/adduser',
          data: {'email': email, 'password': password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      print(e.response?.data['msg'] as String);
      return e.response;
    }
  }

  Future<Response?> token(String refreshToken) async {
    try {
      dio.options.headers['Authorization'] = refreshToken;
      return await dio.get('$backendUrl/api/token',
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return e.response;
    }
  }
}
