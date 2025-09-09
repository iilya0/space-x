import 'package:space_x/src/core/models/launch.dart';
import 'package:space_x/src/core/models/rocket.dart';
import 'package:space_x/src/features/home/data/home_service.dart';

class HomeRepository {
  const HomeRepository(this._service);
  final HomeService _service;

  Future<List<Rocket>> getRockets() => _service.fetchRockets();

  Future<List<Launch>> getLaunchesByRocketId(String rocketId) =>
      _service.fetchLaunchesByRocketId(rocketId);
}
