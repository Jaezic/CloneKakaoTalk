import 'package:dio/dio.dart';

extension DioExtension<T> on Response<T> {
  bool get isSuccessful => ((statusCode ?? 500) <= 300);
}
