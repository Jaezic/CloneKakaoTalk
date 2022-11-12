class Response<T> {
  Response({this.statusCode, this.statusMessage, this.data});

  int? statusCode;
  String? statusMessage;
  T? data;
}
