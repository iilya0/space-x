class Rocket {
  final String rocketId;
  final String rocketName;
  final List<String> imageUrls;
  final bool active;

  Rocket({
    required this.rocketId,
    required this.rocketName,
    required this.imageUrls,
    required this.active,
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? images = json['flickr_images'] as List<dynamic>?;
    return Rocket(
      rocketId: (json['rocket_id'] ?? json['id']).toString(),
      rocketName: (json['rocket_name'] ?? json['name']).toString(),
      imageUrls: images == null
          ? <String>[]
          : images
                .map((e) => e.toString())
                .where((e) => e.isNotEmpty)
                .toList(growable: false),
      active: (json['active'] as bool?) ?? false,
    );
  }
}
