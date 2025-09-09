import 'package:flutter/material.dart';
import 'package:space_x/src/core/models/launch.dart';
import 'package:space_x/src/core/resources/app_colors.dart';
import 'package:space_x/src/core/resources/app_text_styles.dart';

class MissionsList extends StatelessWidget {
  const MissionsList({required this.launches, super.key});

  final List<Launch> launches;

  @override
  Widget build(BuildContext context) {
    if (launches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No missions available',
            style: TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Missions', style: AppTextStyles.appBarTitleStyle),
        ),
        const SizedBox(height: 18),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: launches.length,
          itemBuilder: (context, index) {
            final launch = launches[index];
            return _buildMissionCard(launch);
          },
        ),
      ],
    );
  }

  Widget _buildMissionCard(Launch launch) {
    final date = launch.launchDateUtc;
    final formattedDate = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
        : 'TBD';
    final formattedTime = date != null
        ? '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}'
        : 'TBD';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDate, style: AppTextStyles.textMedium16),
              const SizedBox(height: 2),
              Text(formattedTime, style: AppTextStyles.textRegular16),
            ],
          ),
          const SizedBox(width: 21),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(launch.missionName, style: AppTextStyles.cardTitleStyle),
                const SizedBox(height: 2),
                if (launch.details != null && launch.details!.isNotEmpty) ...[
                  Text(
                    launch.details!,
                    style: AppTextStyles.textRegular16,
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
