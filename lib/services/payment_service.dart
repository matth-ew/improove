import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:improove/const/text.dart';

class PaymentService {
  Dio dio = Dio();

  Future<Response?> validateSubscriptions(
    String source,
    String verificationData,
    String productId,
    String token,
  ) async {
    try {
      dio.options.headers['Authorization'] = token;
      debugPrint("service validateSubscriptions");
      return await dio.post(
        '$backendUrl/api/validateSubscription',
        data: {
          'source': source,
          'verificationData': verificationData,
          'productId': productId,
        },
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
    } on DioError catch (e) {
      debugPrint("VALIDATE PAYMENT ERROR ${e.toString()}");
      return null;
    }
  }
}
