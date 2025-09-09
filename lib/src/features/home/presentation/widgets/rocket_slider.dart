import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/src/core/models/rocket.dart';
import 'package:space_x/src/core/resources/app_colors.dart';
import 'package:space_x/src/core/widgets/custom_circular_progress_indicator.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_event.dart';
import 'package:space_x/src/features/home/presentation/bloc/home_state.dart';

class RocketSlider extends StatefulWidget {
  const RocketSlider({
    required this.rockets,
    super.key,
  });

  final List<Rocket> rockets;

  @override
  State<RocketSlider> createState() => _RocketSliderState();
}

class _RocketSliderState extends State<RocketSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rockets.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No rockets available',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is HomeRocketsLoaded) {
          currentIndex = state.currentIndex;
        }

        return Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<HomeBloc>().add(HomePageChanged(index));
                },
                itemCount: widget.rockets.length,
                itemBuilder: (context, index) {
                  final rocket = widget.rockets[index];
                  final isSelected = index == currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: isSelected ? 8.0 : 16.0,
                      vertical: isSelected ? 8.0 : 16.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: rocket.imageUrls.isNotEmpty
                          ? Image.network(
                              rocket.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGray,
                                  child: const Icon(
                                    Icons.rocket_launch,
                                    color: AppColors.white,
                                    size: 50,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: AppColors.lightGray,
                                      child: const Center(
                                        child:
                                            CustomCircularProgressIndicator(),
                                      ),
                                    );
                                  },
                            )
                          : Container(
                              color: AppColors.lightGray,
                              child: const Icon(
                                Icons.rocket_launch,
                                color: AppColors.white,
                                size: 50,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.rockets.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentIndex
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
