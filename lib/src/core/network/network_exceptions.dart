class NoInternetException implements Exception {
  const NoInternetException();

  String get message => 'NO INTERNET CONNECTION';
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;
}
