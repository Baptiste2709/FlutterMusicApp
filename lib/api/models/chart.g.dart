// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartItem _$ChartItemFromJson(Map<String, dynamic> json) => ChartItem(
      albumId: json['idAlbum'] as String?,
      artistId: json['idArtist'] as String?,
      trackId: json['idTrack'] as String?,
      albumName: json['strAlbum'] as String?,
      artistName: json['strArtist'] as String?,
      trackName: json['strTrack'] as String?,
      albumThumb: json['strAlbumThumb'] as String?,
      trackThumb: json['strTrackThumb'] as String?,
      chartPlace: json['intChartPlace'] as String?,
    );

Map<String, dynamic> _$ChartItemToJson(ChartItem instance) => <String, dynamic>{
      'idAlbum': instance.albumId,
      'idArtist': instance.artistId,
      'idTrack': instance.trackId,
      'strAlbum': instance.albumName,
      'strArtist': instance.artistName,
      'strTrack': instance.trackName,
      'strAlbumThumb': instance.albumThumb,
      'strTrackThumb': instance.trackThumb,
      'intChartPlace': instance.chartPlace,
    };

ChartResponse _$ChartResponseFromJson(Map<String, dynamic> json) =>
    ChartResponse(
      trending: (json['trending'] as List<dynamic>?)
          ?.map((e) => ChartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      loves: (json['loves'] as List<dynamic>?)
          ?.map((e) => ChartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      albums: (json['albums'] as List<dynamic>?)
          ?.map((e) => ChartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tracks: (json['tracks'] as List<dynamic>?)
          ?.map((e) => ChartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChartResponseToJson(ChartResponse instance) =>
    <String, dynamic>{
      'trending': instance.trending,
      'loves': instance.loves,
      'albums': instance.albums,
      'tracks': instance.tracks,
    };
