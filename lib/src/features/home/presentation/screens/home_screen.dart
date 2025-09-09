import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/src/core/resources/app_colors.dart';
import 'package:space_x/src/core/widgets/custom_app_bar.dart';
import 'package:space_x/src/core/widgets/custom_circular_progress_indicator.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_event.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_state.dart';
import 'package:space_x/src/features/home/presentation/widgets/rocket_slider.dart';
import 'package:space_x/src/features/home/presentation/widgets/missions_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SpaceX Launches'),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeRefresh());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeRocketsLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  RocketSlider(
                    rockets: state.rockets,
                  ),
                  const SizedBox(height: 24),
                  if (state.isLoadingLaunches)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CustomCircularProgressIndicator()),
                    )
                  else
                    MissionsList(launches: state.launches),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return const Center(
            child: Text(
              'No rockets available',
              style: TextStyle(color: AppColors.lightGray),
            ),
          );
        },
      ),
    );
  }
}
