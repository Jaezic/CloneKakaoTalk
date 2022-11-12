class ApiResponse<T> {
  ApiResponse({required this.result, this.value, this.errorMsg = ''});

  String errorMsg;
  bool result;
  T? value;
}
