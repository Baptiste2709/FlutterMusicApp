class SingleModel {
  final int position;
  final String title;
  final String artist;
  final String imageUrl;
  final String artistId; // Ajout de l'ID de l'artiste
    final String trackId; // Ajouter cette propriété



  SingleModel({
    required this.position,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.artistId, // Rendre obligatoire l'ID de l'artiste
        required this.trackId, // Rendre obligatoire l'ID du titre

  });

  factory SingleModel.fromJson(Map<String, dynamic> json) {
    return SingleModel(
      position: json['position'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['image'] ?? '',
      artistId: json['artistId'] ?? '', // Récupérer l'ID de l'artiste
      trackId: json['trackId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'artist': artist,
      'image': imageUrl,
      'artistId': artistId,
      'trackId' : trackId
    };
  }
}