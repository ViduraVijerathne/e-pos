class MethodResponse<T>{
  final bool isSuccess;
  final String message;
  final T data;

  MethodResponse({required this.isSuccess, required this.message, required this.data});
}