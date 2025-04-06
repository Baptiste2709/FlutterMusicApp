import 'package:json_annotation/json_annotation.dart';

part 'chart.g.dart';

@JsonSerializable()
class ChartItem {
  @JsonKey(name: 'idAlbum')
  final String? albumId;
  
  @JsonKey(name: 'idArtist')
  final String? artistId;
  
  @JsonKey(name: 'idTrack')
  final String? trackId;
  
  @JsonKey(name: 'strAlbum')
  final String? albumName;
  
  @JsonKey(name: 'strArtist')
  final String? artistName;
  
  @JsonKey(name: 'strTrack')
  final String? trackName;
  
  @JsonKey(name: 'strAlbumThumb')
  final String? albumThumb;
  
  @JsonKey(name: 'strTrackThumb')
  final String? trackThumb;
  
  @JsonKey(name: 'intChartPlace')
  final String? chartPlace;
  
  ChartItem({
    this.albumId,
    this.artistId,
    this.trackId,
    this.albumName,
    this.artistName,
    this.trackName,
    this.albumThumb,
    this.trackThumb,
    this.chartPlace,
  });
  
  factory ChartItem.fromJson(Map<String, dynamic> json) => _$ChartItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChartItemToJson(this);
}

@JsonSerializable()
class ChartResponse {
  @JsonKey(name: 'trending')
  final List<ChartItem>? trending;
  
  @JsonKey(name: 'loves')
  final List<ChartItem>? loves;
  
  @JsonKey(name: 'albums')
  final List<ChartItem>? albums;
  
  @JsonKey(name: 'tracks')
  final List<ChartItem>? tracks;
  
  ChartResponse({
    this.trending,
    this.loves,
    this.albums,
    this.tracks,
  });
  
  factory ChartResponse.fromJson(Map<String, dynamic> json) => _$ChartResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChartResponseToJson(this);
}