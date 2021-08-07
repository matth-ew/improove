import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:improove/redux/models/models.dart';

const backendUrl = 'http://10.0.2.2:3001';

class TrainingService {
  Dio dio = Dio();

  Future<Map<int, Training>?> getTraining() async {
    try {
      final Response<Map<String, dynamic>> res = await dio.post(
        '$backendUrl/api/getTrainings',
        data: {'id': 1},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
      final Map<int, Training> trainings = {};
      final results = [...res.data!["result"]];
      for (var i = 0; i < results.length; i++) {
        trainings[i] = Training.fromJson(res.data!, i);
      }
      return trainings;
      // return Training.fromJson(
      //     res.data["result.title"].toString(),
      //     res.data["result.duration"].toString(),
      //     res.data["result.preview"].toString());
    } on DioError catch (e) {
      print(e.response?.data['msg']);
      return null;
    }
  }

  Future<Training?> getTrainingById(int id) async {
    try {
      final Response<Map<String, dynamic>> res = await dio.post(
        '$backendUrl/api/getTrainingById',
        data: {'id': id + 1},
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );

      final Training training = Training.fromJson(res.data!, 0);
      return training;
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
