// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchArtistResult _$SearchArtistResultFromJson(Map<String, dynamic> json) =>
    SearchArtistResult(
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchArtistResultToJson(SearchArtistResult instance) =>
    <String, dynamic>{
      'artists': instance.artists,
    };

SearchAlbumResult _$SearchAlbumResultFromJson(Map<String, dynamic> json) =>
    SearchAlbumResult(
      albums: (json['album'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchAlbumResultToJson(SearchAlbumResult instance) =>
    <String, dynamic>{
      'album': instance.albums,
    };
