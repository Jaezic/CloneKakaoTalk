class Response<T> {
  Response({this.statusCode, this.statusMessage, this.data});

  int? statusCode;
  String? statusMessage;
  T? data;
  bool get isSuccessful => ((statusCode ?? 500) == 200);
}
