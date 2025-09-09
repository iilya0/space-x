import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/src/core/resources/app_colors.dart';
import 'package:space_x/src/features/home/presentation/screens/home_screen.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_event.dart';
import 'package:space_x/src/features/home/domain/home_repository.dart';
import 'package:space_x/src/features/home/data/home_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(repository: HomeRepository(HomeService()))
            ..add(const HomeLoadRockets()),
      child: MaterialApp(
        title: 'SpaceX Launches',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
          ),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.white,
            surface: AppColors.black,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
