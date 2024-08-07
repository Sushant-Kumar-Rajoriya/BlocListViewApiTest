import 'package:bloc_api_call_listview/app/utils/constant.dart';
import 'package:flutter/foundation.dart';

import 'dio_with_interceptors.dart';

class DioApiBaseHelper {
  static String searchRepositories = 'search/repositories';

  static get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await getDio().get(
        Constant.restBaseUrl + url,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
        print(e);
      }
    }
    return null;
  }

  static postDio(String url, dynamic data) async {
    try {
      final response = await getDio().post(
        Constant.restBaseUrl + url,
        data: data,
      );
      return response.data;
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
    return null;
  }

  static putDio(String url, dynamic data) async {
    try {
      final response = await getDio().put(
        Constant.restBaseUrl + url,
        data: data,
      );
      return response.data;
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
    return null;
  }

  static deleteDio(String url, dynamic id) async {
    try {
      final response = await getDio().delete(
        "${Constant.restBaseUrl}$url/$id",
      );
      return response.data;
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
    return null;
  }
}
