import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:improove/redux/models/models.dart';

const backendUrl = 'http://10.0.2.2:3001';

class TrainingService {
  Dio dio = Dio();

  Future<Response?> getTrainings() async {
    try {
      return await dio.post(
        '$backendUrl/api/getTrainings',
        // data: {'id': 1},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );

      // return Training.fromJson(
      //     res.data["result.title"].toString(),
      //     res.data["result.duration"].toString(),
      //     res.data["result.preview"].toString());
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Response?> getTrainingById(int id) async {
    try {
      return await dio.post(
        '$backendUrl/api/getTrainingById',
        data: {'id': id},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Response?> setTrainingDescription(
      int id, String text, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setTrainingDescription',
        data: {'id': id, 'text': text},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Response?> setExerciseTips(
      int id, String title, String tips, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setExerciseTips',
        data: {'id': id, 'title': title, 'tips': tips},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Response?> setExerciseHow(
      int id, String title, String how, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setExerciseHow',
        data: {'id': id, 'title': title, 'how': how},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Response?> setExerciseMistakes(
      int id, String title, String mistakes, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setExerciseMistakes',
        data: {'id': id, 'title': title, 'mistakes': mistakes},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }
}