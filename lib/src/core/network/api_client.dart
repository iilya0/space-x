import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:space_x/src/core/models/launch.dart';
import 'package:space_x/src/core/models/rocket.dart';
import 'package:space_x/src/core/errors/api_exception.dart';
import 'package:space_x/src/core/resources/app_exception_keys.dart';

class ApiClient {
  static const String _baseUrl = 'https://api.spacexdata.com/v3';
  final _httpClient = http.Client();

  Future<List<Rocket>> fetchRockets() async {
    final dynamic jsonData = await _get('/rockets');

    if (jsonData is! List) {
      throw ApiException(key: AppExceptionKeys.unexpectedResponse);
    }

    return jsonData
        .cast<Map<String, dynamic>>()
        .map<Rocket>((Map<String, dynamic> e) => Rocket.fromJson(e))
        .toList(growable: false);
  }

  Future<Rocket> fetchRocketById(String rocketId) async {
    final dynamic jsonData = await _get('/rockets/$rocketId');

    if (jsonData is! Map<String, dynamic>) {
      throw ApiException(key: AppExceptionKeys.unexpectedResponse);
    }

    return Rocket.fromJson(jsonData);
  }

  Future<List<Launch>> fetchLaunchesByRocketId(String rocketId) async {
    final dynamic jsonData = await _get(
      '/launches?rocket_id=${Uri.encodeQueryComponent(rocketId)}',
    );

    if (jsonData is! List) {
      throw ApiException(key: AppExceptionKeys.unexpectedResponse);
    }

    return jsonData
        .cast<Map<String, dynamic>>()
        .map<Launch>((Map<String, dynamic> e) => Launch.fromJson(e))
        .toList(growable: false);
  }

  Future<dynamic> _get(String path) async {
    final Uri url = Uri.parse(_baseUrl + path);
    final http.Response response;

    try {
      response = await _httpClient.get(url);
    } catch (e) {
      throw ApiException(key: AppExceptionKeys.networkError);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        key: AppExceptionKeys.httpError,
      );
    }

    try {
      return json.decode(response.body);
    } catch (e) {
      throw ApiException(key: AppExceptionKeys.parseError);
    }
  }

  void close() {
    _httpClient.close();
  }
}
