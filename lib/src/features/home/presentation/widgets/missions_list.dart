import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
            return _buildMissionCard(context, launch);
          },
        ),
      ],
    );
  }

  Widget _buildMissionCard(BuildContext context, Launch launch) {
    final date = launch.launchDateUtc;
    final formattedDate = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
        : 'TBD';
    final formattedTime = date != null
        ? '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}'
        : 'TBD';

    return GestureDetector(
      onTap: () => _launchWikipediaUrl(context, launch.wikipedia),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        padding: const EdgeInsets.all(16),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          launch.missionName,
                          style: AppTextStyles.cardTitleStyle,
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }

  Future<void> _launchWikipediaUrl(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) {
      _showSnackBar(context, 'No Wikipedia page available for this mission');
      return;
    }

    final Uri uri = _normalizeUrl(url);

    try {
      if (await _tryLaunch(uri, LaunchMode.externalApplication)) return;
      if (await _tryLaunch(uri, LaunchMode.inAppBrowserView)) return;
      if (await _tryLaunch(uri, LaunchMode.platformDefault)) return;

      if (context.mounted) {
        _showSnackBar(context, 'Could not open Wikipedia page');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error opening Wikipedia: $e');
      }
    }
  }

  Uri _normalizeUrl(String url) {
    final normalized = url.trim();
    return Uri.parse(normalized);
  }

  Future<bool> _tryLaunch(Uri uri, LaunchMode mode) async {
    return await launchUrl(uri, mode: mode);
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.red),
    );
  }
}
