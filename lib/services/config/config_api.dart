import 'package:dio/dio.dart';

class DioConfig {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api',
    validateStatus: (_) => true,
  ));
}
