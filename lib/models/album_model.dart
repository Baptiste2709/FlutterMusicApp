class AlbumModel {
  final int position;
  final String title;
  final String artist;
  final String imageUrl;

  AlbumModel({
    required this.position,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
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