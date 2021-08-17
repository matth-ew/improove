import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:improove/redux/models/models.dart';

const backendUrl = 'http://10.0.2.2:3001';

class TrainerService {
  Dio dio = Dio();

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
      print(e.response?.data['msg']);
      return null;
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
      print(e.response?.data['msg']);
      return null;
    }
  }
}
