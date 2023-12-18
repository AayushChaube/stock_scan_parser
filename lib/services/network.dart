import 'dart:io';

import 'package:dio/dio.dart';

Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {

      return false;
    }
    
    return true;
  }

  Dio getDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'http://coding-assignment.bombayrunning.com/',
        contentType: 'application/json',
        validateStatus: (int? status) {
          return status! <= 500;
        },
      ),
    );

    return dio;
  }