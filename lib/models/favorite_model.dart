class FavoriteArtist {
  final String id;
  final String name;
  final String imageUrl;

  FavoriteArtist({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory FavoriteArtist.fromJson(Map<String, dynamic> json) {
    return FavoriteArtist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class FavoriteAlbum {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;

  FavoriteAlbum({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
    };
  }

  factory FavoriteAlbum.fromJson(Map<String, dynamic> json) {
    return FavoriteAlbum(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}