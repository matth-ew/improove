import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/const/text.dart';

class UserService {
  Dio dio = Dio();

  Future<Response?> getInfo(String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.get('$backendUrl/api/getinfo');
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }

  Future<Response?> saveTraining(int trainingId, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/userAddSavedTraining',
        data: {'trainingId': trainingId},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }

  Future<Response?> removeTraining(int trainingId, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/userDeleteSavedTraining',
        data: {'trainingId': trainingId},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }

  Future<Response?> changeProfileImage(File image, String token) async {
    try {
      final String fileName = image.path.split('/').last;
      final FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      dio.options.headers['Authorization'] = token;
      return await dio.post('$backendUrl/api/userChangeProfileImage',
          data: formData);
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }

  Future<Response?> changeProfileInfo(
      String name, String surname, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/userChangeProfileInfo',
        data: {
          'name': name,
          "surname": surname,
        },
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }
}
