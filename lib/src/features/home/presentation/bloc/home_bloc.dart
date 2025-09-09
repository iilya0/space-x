import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/src/features/home/domain/home_repository.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_event.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required HomeRepository repository})
    : _repository = repository,
      super(const HomeInitial()) {
    on<HomeLoadRockets>(_onLoadRockets);
    on<HomeRocketSelected>(_onRocketSelected);
    on<HomePageChanged>(_onPageChanged);
    on<HomeRefresh>(_onRefresh);
  }

  final HomeRepository _repository;

  Future<void> _onLoadRockets(
    HomeLoadRockets event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      final rockets = await _repository.getRockets();

      if (rockets.isEmpty) {
        emit(const HomeError('No rockets available'));
        return;
      }

      final selectedRocketId = rockets.first.rocketId;
      final launches = await _repository.getLaunchesByRocketId(
        selectedRocketId,
      );

      emit(
        HomeRocketsLoaded(
          rockets: rockets,
          selectedRocketId: selectedRocketId,
          currentIndex: 0,
          launches: launches,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRocketSelected(
    HomeRocketSelected event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeRocketsLoaded) return;

    if (currentState.selectedRocketId == event.rocketId) return;

    try {
      emit(currentState.copyWith(isLoadingLaunches: true));

      final launches = await _repository.getLaunchesByRocketId(event.rocketId);

      final rocketIndex = currentState.rockets.indexWhere(
        (rocket) => rocket.rocketId == event.rocketId,
      );

      emit(
        currentState.copyWith(
          selectedRocketId: event.rocketId,
          currentIndex: rocketIndex >= 0
              ? rocketIndex
              : currentState.currentIndex,
          launches: launches,
          isLoadingLaunches: false,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onPageChanged(
    HomePageChanged event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeRocketsLoaded) return;

    if (currentState.currentIndex == event.index) return;

    final selectedRocket = currentState.rockets[event.index];

    emit(currentState.copyWith(currentIndex: event.index));

    add(HomeRocketSelected(selectedRocket.rocketId));
  }

  Future<void> _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    add(const HomeLoadRockets());
  }
}
