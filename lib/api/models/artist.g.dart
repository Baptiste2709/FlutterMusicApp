// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['idArtist'] as String?,
      name: json['strArtist'] as String?,
      style: json['strStyle'] as String?,
      genre: json['strGenre'] as String?,
      formedYear: json['intFormedYear'] as String?,
      country: json['strCountry'] as String?,
      website: json['strWebsite'] as String?,
      facebook: json['strFacebook'] as String?,
      twitter: json['strTwitter'] as String?,
      biographyEN: json['strBiographyEN'] as String?,
      biographyFR: json['strBiographyFR'] as String?,
      biographyDE: json['strBiographyDE'] as String?,
      biographyIT: json['strBiographyIT'] as String?,
      biographyJP: json['strBiographyJP'] as String?,
      biographyRU: json['strBiographyRU'] as String?,
      biographyES: json['strBiographyES'] as String?,
      artistThumb: json['strArtistThumb'] as String?,
      artistLogo: json['strArtistLogo'] as String?,
      artistBanner: json['strArtistBanner'] as String?,
      musicBrainzId: json['strMusicBrainzID'] as String?,
      lastFMChart: json['strLastFMChart'] as String?,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'idArtist': instance.id,
      'strArtist': instance.name,
      'strStyle': instance.style,
      'strGenre': instance.genre,
      'intFormedYear': instance.formedYear,
      'strCountry': instance.country,
      'strWebsite': instance.website,
      'strFacebook': instance.facebook,
      'strTwitter': instance.twitter,
      'strBiographyEN': instance.biographyEN,
      'strBiographyFR': instance.biographyFR,
      'strBiographyDE': instance.biographyDE,
      'strBiographyIT': instance.biographyIT,
      'strBiographyJP': instance.biographyJP,
      'strBiographyRU': instance.biographyRU,
      'strBiographyES': instance.biographyES,
      'strArtistThumb': instance.artistThumb,
      'strArtistLogo': instance.artistLogo,
      'strArtistBanner': instance.artistBanner,
      'strMusicBrainzID': instance.musicBrainzId,
      'strLastFMChart': instance.lastFMChart,
    };

ArtistResponse _$ArtistResponseFromJson(Map<String, dynamic> json) =>
    ArtistResponse(
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistResponseToJson(ArtistResponse instance) =>
    <String, dynamic>{
      'artists': instance.artists,
    };
