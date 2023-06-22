import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:group_chat_app/core/strings.dart';

class DioHelper {
  static late final Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: '',
        receiveDataWhenStatusError: true,
        headers: {
          'Authorization' : 'key= ${Stringat.servicesKey}',
          'Content-Type' : 'application/json',
        },
      ),
    );
  }
}
