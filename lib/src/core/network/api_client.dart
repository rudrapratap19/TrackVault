import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'network_exceptions.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<Map<String, dynamic>> getJson(Uri url) async {
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('HTTP ${response.statusCode}');
      }
      final body = json.decode(response.body);
      if (body is Map<String, dynamic>) {
        return body;
      }
      throw ApiException('Invalid response format');
    } on SocketException {
      throw const NoInternetException();
    } on HttpException {
      throw const NoInternetException();
    } on FormatException {
      throw ApiException('Invalid response format');
    } catch (e) {
      if (e is NoInternetException || e is ApiException) {
        rethrow;
      }
      throw const NoInternetException();
    }
  }
}
