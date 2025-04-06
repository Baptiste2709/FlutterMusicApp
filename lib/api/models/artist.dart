import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonSerializable()
class Artist {
  @JsonKey(name: 'idArtist')
  final String? id;
  
  @JsonKey(name: 'strArtist')
  final String? name;
  
  @JsonKey(name: 'strStyle')
  final String? style;
  
  @JsonKey(name: 'strGenre')
  final String? genre;
  
  @JsonKey(name: 'intFormedYear')
  final String? formedYear;
  
  @JsonKey(name: 'strCountry')
  final String? country;
  
  @JsonKey(name: 'strWebsite')
  final String? website;
  
  @JsonKey(name: 'strFacebook')
  final String? facebook;
  
  @JsonKey(name: 'strTwitter')
  final String? twitter;
  
  @JsonKey(name: 'strBiographyEN')
  final String? biographyEN;
  
  @JsonKey(name: 'strBiographyFR')
  final String? biographyFR;
  
  @JsonKey(name: 'strBiographyDE')
  final String? biographyDE;
  
  @JsonKey(name: 'strBiographyIT')
  final String? biographyIT;
  
  @JsonKey(name: 'strBiographyJP')
  final String? biographyJP;
  
  @JsonKey(name: 'strBiographyRU')
  final String? biographyRU;
  
  @JsonKey(name: 'strBiographyES')
  final String? biographyES;
  
  @JsonKey(name: 'strArtistThumb')
  final String? artistThumb;
  
  @JsonKey(name: 'strArtistLogo')
  final String? artistLogo;
  
  @JsonKey(name: 'strArtistBanner')
  final String? artistBanner;
  
  @JsonKey(name: 'strMusicBrainzID')
  final String? musicBrainzId;
  
  @JsonKey(name: 'strLastFMChart')
  final String? lastFMChart;
  
  Artist({
    this.id,
    this.name,
    this.style,
    this.genre,
    this.formedYear,
    this.country,
    this.website,
    this.facebook,
    this.twitter,
    this.biographyEN,
    this.biographyFR,
    this.biographyDE,
    this.biographyIT,
    this.biographyJP,
    this.biographyRU,
    this.biographyES,
    this.artistThumb,
    this.artistLogo,
    this.artistBanner,
    this.musicBrainzId,
    this.lastFMChart,
  });
  
  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
  
  Map<String, dynamic> toJson() => _$ArtistToJson(this);
  
  String getBiography(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return biographyFR ?? biographyEN ?? '';
      case 'de':
        return biographyDE ?? biographyEN ?? '';
      case 'it':
        return biographyIT ?? biographyEN ?? '';
      case 'jp':
        return biographyJP ?? biographyEN ?? '';
      case 'ru':
        return biographyRU ?? biographyEN ?? '';
      case 'es':
        return biographyES ?? biographyEN ?? '';
      default:
        return biographyEN ?? '';
    }
  }
}

@JsonSerializable()
class ArtistResponse {
  @JsonKey(name: 'artists')
  final List<Artist>? artists;
  
  ArtistResponse({this.artists});
  
  factory ArtistResponse.fromJson(Map<String, dynamic> json) => _$ArtistResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ArtistResponseToJson(this);
}