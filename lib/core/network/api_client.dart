import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../session/session.dart';
import 'api_exception.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  ApiClient(this._ref) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _ref.read(sessionProvider).token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _ref.read(sessionProvider.notifier).logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Ref _ref;
  late final Dio _dio;


  Future<T> post<T>(String path, {Map<String, dynamic>? body, required T Function(dynamic json) parser,}) {
    return _send(() => _dio.post(path, data: body), parser);
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) {
    return _send(() => _dio.get(path, queryParameters: query), parser);
  }

  Future<T> _send<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) parser,
  ) async {
    try {
      final response = await request();
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        return parser(response.data);
      }
      throw _fromBody(response.data, status);
    } on DioException catch (e) {
       if(kDebugMode){
         print('DIO ERROR TYPE: ${e.type}');
         print('DIO ERROR MESSAGE: ${e.message}');
         print('DIO ERROR: ${e.error}');
         print('STATUS CODE: ${e.response?.statusCode}');
         print('RESPONSE DATA: ${e.response?.data}');
         print('REQUEST URL: ${e.requestOptions.uri}');
         print('HEADERS: ${e.requestOptions.headers}');
       }
      if (e.type == DioExceptionType.connectionError ) {
        throw const ApiException('No internet connection', statusCode: -1009);
      }

      if ( e.type == DioExceptionType.connectionTimeout) {
        throw const ApiException('Time out error', statusCode: -1009);
      }
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const ApiException('Request timeout');
      }
      if (e.response?.statusCode == 401) {
        throw const ApiException('Unauthorized', statusCode: 401);
      }
      throw _fromBody(e.response?.data, e.response?.statusCode ?? 0);
    }
  }

  ApiException _fromBody(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      final message = (data['errors'] ?? data['message'] ?? '').toString();
      if (message.isNotEmpty) {
        return ApiException(message, statusCode: data['code'] as int? ?? statusCode);
      }
    }
    return ApiException('Invalid response from server', statusCode: statusCode);
  }
}
