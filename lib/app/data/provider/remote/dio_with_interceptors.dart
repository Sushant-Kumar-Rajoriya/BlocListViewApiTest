
import 'package:dio/dio.dart';

import 'app_interceptors.dart';

Dio getDio() {
  Dio dio = Dio();
  dio.interceptors.add(AppInterceptors());
  return dio;
}
