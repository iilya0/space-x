class Launch {
  final String missionName;
  final DateTime? launchDateUtc;
  final bool upcoming;
  final String? details;
  final String? missionPatchSmall;
  final String? missionPatchLarge;
  final String? wikipedia;

  Launch({
    required this.missionName,
    required this.launchDateUtc,
    required this.upcoming,
    required this.details,
    required this.missionPatchSmall,
    required this.missionPatchLarge,
    required this.wikipedia,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? links = json['links'] as Map<String, dynamic>?;
    final String? dateStr = (json['launch_date_utc'] ?? json['date_utc'])
        ?.toString();
    DateTime? parsedDate;
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        parsedDate = DateTime.tryParse(dateStr);
      } catch (_) {
        parsedDate = null;
      }
    }
    return Launch(
      missionName: (json['mission_name'] ?? json['name'])?.toString() ?? '',
      launchDateUtc: parsedDate,
      upcoming: (json['upcoming'] as bool?) ?? false,
      details: json['details'] as String?,
      missionPatchSmall: links == null
          ? null
          : links['mission_patch_small'] as String?,
      missionPatchLarge: links == null
          ? null
          : links['mission_patch'] as String?,
      wikipedia: links == null ? null : links['wikipedia'] as String?,
    );
  }
}
