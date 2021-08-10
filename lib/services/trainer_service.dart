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
}
