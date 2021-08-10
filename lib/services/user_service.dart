import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const backendUrl = 'http://10.0.2.2:3001';

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
}
