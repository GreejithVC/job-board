import 'package:dio/dio.dart';

import 'api_urls.dart';

class ApiHandler {
  final Dio _dio;

  ApiHandler({Dio? dio})
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ));

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return _response(response);
  }

  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
    return _response(response);
  }

  Future<dynamic> put({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.put(
      url,
      data: body,
      options: Options(headers: headers),
    );
    return _response(response);
  }

  Future<dynamic> delete({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.delete(
      url,
      data: body,
      options: Options(headers: headers),
    );
    return _response(response);
  }

  dynamic _response(Response response) {
    if (response.statusCode == 204) return null;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  }
}
