import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(RequestOptions options, handler) async {
    // Map<String, String> headers = {
    //   'Access-Control-Allow-Origin': '*',
    //   'Accept': 'application/json',
    // };
    //options.headers.addAll(headers);
    return super.onRequest(options, handler);
  }

  @override
  onError(DioException err, handler) {
    var response = err.response;
    if (response != null) {

    }
  }
}