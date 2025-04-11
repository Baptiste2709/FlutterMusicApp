class AlbumModel {
  final int position;
  final String title;
  final String artist;
  final String imageUrl;
  final String albumId; // Ajout de l'ID de l'album
  final String artistId; // Ajout de l'ID de l'artiste

  AlbumModel({
    required this.position,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.albumId, // Rendre obligatoire l'ID de l'album
    required this.artistId, // Rendre obligatoire l'ID de l'artiste
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      position: json['position'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['image'] ?? '',
      albumId: json['albumId'] ?? '',
      artistId: json['artistId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'artist': artist,
      'image': imageUrl,
      'albumId': albumId,
      'artistId': artistId,
    };
  }
}