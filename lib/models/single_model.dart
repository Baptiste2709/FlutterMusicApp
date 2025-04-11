class SingleModel {
  final int position;
  final String title;
  final String artist;
  final String imageUrl;

  SingleModel({
    required this.position,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory SingleModel.fromJson(Map<String, dynamic> json) {
    return SingleModel(
      position: json['position'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'artist': artist,
      'image': imageUrl,
    };
  }
}