import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/const/text.dart';

class TrainerService {
  Dio dio = Dio();

  Future<Response?> getLatestTrainers() async {
    try {
      debugPrint("service getLatestTrainers");
      return await dio.post(
        '$backendUrl/api/getLatestTrainers',
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("UE DIOERROR");
      debugPrint(e.response?.data['msg'].toString());
      return null;
    }
  }

  Future<Response?> getTrainerById(int id) async {
    try {
      debugPrint("service getTrainerById");
      return await dio.post(
        '$backendUrl/api/getTrainerById',
        data: {'id': id},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("UE DIOERROR");
      debugPrint(e.response?.data['msg'].toString());
      return null;
    }
  }

  Future<Response?> setTrainerImage(File image, String token) async {
    try {
      final String fileName = image.path.split('/').last;
      final FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      dio.options.headers['Authorization'] = token;
      return await dio.post('$backendUrl/api/userChangeTrainerImage',
          data: formData);
    } on DioError catch (e) {
      debugPrint("GETINFO ERROR ${e.response?.data?['msg']}");
      return e.response;
    }
  }

  Future<Response?> setTrainerDescription(
      int id, String text, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setTrainerDescription',
        data: {'id': id, 'text': text},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("UE DIOERROR");
      debugPrint(e.response?.data['msg'].toString());
      return null;
    }
  }
}
