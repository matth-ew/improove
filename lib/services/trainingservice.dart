import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:improove/redux/models/models.dart';

const backendUrl = 'http://10.0.2.2:3001';

class TrainingService {
  Dio dio = Dio();
  Future<Training?> getTraining() async {
    try {
      final Response<Map<String, dynamic>> res = await dio.post(
        '$backendUrl/api/getTraining',
        data: {'id': 1},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
      return Training.fromJson(res.data!);
      // return Training.fromJson(
      //     res.data["result.title"].toString(),
      //     res.data["result.duration"].toString(),
      //     res.data["result.preview"].toString());
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }
}
