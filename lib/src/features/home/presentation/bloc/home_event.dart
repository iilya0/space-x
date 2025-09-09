import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRockets extends HomeEvent {
  const HomeLoadRockets();
}

class HomeRocketSelected extends HomeEvent {
  const HomeRocketSelected(this.rocketId);

  final String rocketId;

  @override
  List<Object?> get props => [rocketId];
}

class HomePageChanged extends HomeEvent {
  const HomePageChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class HomeRefresh extends HomeEvent {
  const HomeRefresh();
}
