import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  @JsonKey(name: 'idAlbum')
  final String? id;
  
  @JsonKey(name: 'idArtist')
  final String? artistId;
  
  @JsonKey(name: 'strAlbum')
  final String? name;
  
  @JsonKey(name: 'strArtist')
  final String? artist;
  
  @JsonKey(name: 'intYearReleased')
  final String? yearReleased;
  
  @JsonKey(name: 'strAlbumThumb')
  final String? albumThumb;
  
  @JsonKey(name: 'strDescriptionEN')
  final String? descriptionEN;
  
  @JsonKey(name: 'strDescriptionFR')
  final String? descriptionFR;
  
  @JsonKey(name: 'strDescriptionDE')
  final String? descriptionDE;
  
  @JsonKey(name: 'strDescriptionIT')
  final String? descriptionIT;
  
  @JsonKey(name: 'strDescriptionJP')
  final String? descriptionJP;
  
  @JsonKey(name: 'strDescriptionRU')
  final String? descriptionRU;
  
  @JsonKey(name: 'strDescriptionES')
  final String? descriptionES;
  
  @JsonKey(name: 'strGenre')
  final String? genre;
  
  @JsonKey(name: 'strStyle')
  final String? style;
  
  @JsonKey(name: 'strLabel')
  final String? label;
  
  @JsonKey(name: 'intSales')
  final String? sales;
  
  @JsonKey(name: 'strAlbumThumbHQ')
  final String? albumThumbHQ;
  
  Album({
    this.id,
    this.artistId,
    this.name,
    this.artist,
    this.yearReleased,
    this.albumThumb,
    this.descriptionEN,
    this.descriptionFR, 
    this.descriptionDE,
    this.descriptionIT,
    this.descriptionJP,
    this.descriptionRU,
    this.descriptionES,
    this.genre,
    this.style,
    this.label,
    this.sales,
    this.albumThumbHQ,
  });
  
  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
  
  Map<String, dynamic> toJson() => _$AlbumToJson(this);
  
  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return descriptionFR ?? descriptionEN ?? '';
      case 'de':
        return descriptionDE ?? descriptionEN ?? '';
      case 'it':
        return descriptionIT ?? descriptionEN ?? '';
      case 'jp':
        return descriptionJP ?? descriptionEN ?? '';
      case 'ru':
        return descriptionRU ?? descriptionEN ?? '';
      case 'es':
        return descriptionES ?? descriptionEN ?? '';
      default:
        return descriptionEN ?? '';
    }
  }
}

@JsonSerializable()
class AlbumResponse {
  @JsonKey(name: 'album')
  final List<Album>? albums;
  
  AlbumResponse({this.albums});
  
  factory AlbumResponse.fromJson(Map<String, dynamic> json) => _$AlbumResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AlbumResponseToJson(this);
}