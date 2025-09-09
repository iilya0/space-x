import 'package:space_x/src/core/models/launch.dart';
import 'package:space_x/src/core/models/rocket.dart';
import 'package:space_x/src/core/network/api_client.dart';

class HomeService {
  HomeService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Rocket>> fetchRockets() {
    return _apiClient.fetchRockets();
  }

  Future<List<Launch>> fetchLaunchesByRocketId(String rocketId) {
    return _apiClient.fetchLaunchesByRocketId(rocketId);
  }
}
