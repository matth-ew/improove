import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:improove/redux/models/models.dart';

const backendUrl = 'http://10.0.2.2:3001';

class TrainerService {
  Dio dio = Dio();

  Future<User?> getTrainerById(int id) async {
    try {
      final Response<Map<String, dynamic>> res = await dio.post(
        '$backendUrl/api/getTrainerById',
        data: {'id': id + 1},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );

      final User trainer = User.fromJson(res.data!);
      return trainer;
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
