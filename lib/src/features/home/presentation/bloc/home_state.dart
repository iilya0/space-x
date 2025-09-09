import 'package:equatable/equatable.dart';
import 'package:space_x/src/core/models/rocket.dart';
import 'package:space_x/src/core/models/launch.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeRocketsLoaded extends HomeState {
  const HomeRocketsLoaded({
    required this.rockets,
    required this.selectedRocketId,
    required this.currentIndex,
    this.launches = const [],
    this.isLoadingLaunches = false,
  });

  final List<Rocket> rockets;
  final String selectedRocketId;
  final int currentIndex;
  final List<Launch> launches;
  final bool isLoadingLaunches;

  @override
  List<Object?> get props => [
    rockets,
    selectedRocketId,
    currentIndex,
    launches,
    isLoadingLaunches,
  ];

  HomeRocketsLoaded copyWith({
    List<Rocket>? rockets,
    String? selectedRocketId,
    int? currentIndex,
    List<Launch>? launches,
    bool? isLoadingLaunches,
  }) {
    return HomeRocketsLoaded(
      rockets: rockets ?? this.rockets,
      selectedRocketId: selectedRocketId ?? this.selectedRocketId,
      currentIndex: currentIndex ?? this.currentIndex,
      launches: launches ?? this.launches,
      isLoadingLaunches: isLoadingLaunches ?? this.isLoadingLaunches,
    );
  }
}

class HomeLaunchesLoaded extends HomeState {
  const HomeLaunchesLoaded({
    required this.rockets,
    required this.selectedRocketId,
    required this.launches,
  });

  final List<Rocket> rockets;
  final String selectedRocketId;
  final List<Launch> launches;

  @override
  List<Object?> get props => [rockets, selectedRocketId, launches];
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
