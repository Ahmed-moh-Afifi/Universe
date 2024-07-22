class ApiDataResponse<T> {
  final T data;
  final Future<ApiDataResponse<T>> Function() nextPage;

  ApiDataResponse({required this.data, required this.nextPage});
}
