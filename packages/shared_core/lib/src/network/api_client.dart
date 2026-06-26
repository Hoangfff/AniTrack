import 'package:dio/dio.dart';
import 'interceptors.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  late final Dio jikanClient;
  late final Dio anikotoClient;
  late final Dio localClient;

  ApiClient._internal() {
    jikanClient = Dio(
      BaseOptions(
        baseUrl: 'https://api.jikan.moe/v4',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    )..interceptors.add(AppInterceptor());

    anikotoClient = Dio(
      BaseOptions(
        baseUrl: 'https://anikotoapi.site/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    )..interceptors.add(AppInterceptor());

    localClient = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    )..interceptors.add(AppInterceptor());
  }
}
