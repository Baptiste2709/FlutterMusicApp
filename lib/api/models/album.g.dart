// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      id: json['idAlbum'] as String?,
      artistId: json['idArtist'] as String?,
      name: json['strAlbum'] as String?,
      artist: json['strArtist'] as String?,
      yearReleased: json['intYearReleased'] as String?,
      albumThumb: json['strAlbumThumb'] as String?,
      descriptionEN: json['strDescriptionEN'] as String?,
      descriptionFR: json['strDescriptionFR'] as String?,
      descriptionDE: json['strDescriptionDE'] as String?,
      descriptionIT: json['strDescriptionIT'] as String?,
      descriptionJP: json['strDescriptionJP'] as String?,
      descriptionRU: json['strDescriptionRU'] as String?,
      descriptionES: json['strDescriptionES'] as String?,
      genre: json['strGenre'] as String?,
      style: json['strStyle'] as String?,
      label: json['strLabel'] as String?,
      sales: json['intSales'] as String?,
      albumThumbHQ: json['strAlbumThumbHQ'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'idAlbum': instance.id,
      'idArtist': instance.artistId,
      'strAlbum': instance.name,
      'strArtist': instance.artist,
      'intYearReleased': instance.yearReleased,
      'strAlbumThumb': instance.albumThumb,
      'strDescriptionEN': instance.descriptionEN,
      'strDescriptionFR': instance.descriptionFR,
      'strDescriptionDE': instance.descriptionDE,
      'strDescriptionIT': instance.descriptionIT,
      'strDescriptionJP': instance.descriptionJP,
      'strDescriptionRU': instance.descriptionRU,
      'strDescriptionES': instance.descriptionES,
      'strGenre': instance.genre,
      'strStyle': instance.style,
      'strLabel': instance.label,
      'intSales': instance.sales,
      'strAlbumThumbHQ': instance.albumThumbHQ,
    };

AlbumResponse _$AlbumResponseFromJson(Map<String, dynamic> json) =>
    AlbumResponse(
      albums: (json['album'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumResponseToJson(AlbumResponse instance) =>
    <String, dynamic>{
      'album': instance.albums,
    };
