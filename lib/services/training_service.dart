import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:improove/const/text.dart';

class TrainingService {
  Dio dio = Dio();

  Future<Response?> getTrainings([List<int>? ids, int? newest]) async {
    try {
      debugPrint(
          "service getTrainings " + ids.toString() + " " + newest.toString());
      return await dio.post(
        '$backendUrl/api/getTrainings',
        data: {'ids': ids, 'newest': newest},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("GETTRAININGS ERROR ${e.toString()}");
      return null;
    }
  }

  Future<Response?> getWeekTraining() async {
    try {
      return await dio.post(
        '$backendUrl/api/getWeekTraining',
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("GETWEEKTRAINING ERROR ${e.toString()}");
      return null;
    }
  }

  Future<Response?> getTrainingById(int id, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      debugPrint("service getTrainingById");
      return await dio.post(
        '$backendUrl/api/getTrainingById',
        data: {'id': id},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
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
      debugPrint(e.response?.data['msg'].toString());
      return null;
    }
  }

  Future<Response?> setExerciseDescription(
      int id, String title, String description, String token) async {
    try {
      dio.options.headers['Authorization'] = token;
      return await dio.post(
        '$backendUrl/api/setExerciseDescription',
        data: {'id': id, 'title': title, 'description': description},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint(e.response?.data['msg'].toString());
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
      debugPrint(e.response?.data['msg'].toString());
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
      debugPrint(e.response?.data['msg'].toString());
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
      debugPrint(e.response?.data['msg'].toString());
      return null;
    }
  }
}
