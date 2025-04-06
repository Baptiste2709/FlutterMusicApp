import 'package:json_annotation/json_annotation.dart';
import 'album.dart';
import 'artist.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchArtistResult {
  @JsonKey(name: 'artists')
  final List<Artist>? artists;
  
  SearchArtistResult({this.artists});
  
  factory SearchArtistResult.fromJson(Map<String, dynamic> json) => _$SearchArtistResultFromJson(json);
  
  Map<String, dynamic> toJson() => _$SearchArtistResultToJson(this);
}

@JsonSerializable()
class SearchAlbumResult {
  @JsonKey(name: 'album')
  final List<Album>? albums;
  
  SearchAlbumResult({this.albums});
  
  factory SearchAlbumResult.fromJson(Map<String, dynamic> json) => _$SearchAlbumResultFromJson(json);
  
  Map<String, dynamic> toJson() => _$SearchAlbumResultToJson(this);
}

/// This class is used to merge search results from both artists and albums
class CombinedSearchResults {
  final List<Artist> artists;
  final Map<String, List<Album>> albumsByArtist;

  CombinedSearchResults({
    required this.artists,
    required this.albumsByArtist,
  });

  // Factory constructor to merge search results
  factory CombinedSearchResults.fromSearchResults({
    required SearchArtistResult? artistResults,
    required Map<String, SearchAlbumResult>? albumsResults,
  }) {
    final artists = artistResults?.artists ?? [];
    final albumsByArtist = <String, List<Album>>{};

    // Organize albums by artist ID
    if (albumsResults != null) {
      albumsResults.forEach((artistId, albumResult) {
        if (albumResult.albums != null && albumResult.albums!.isNotEmpty) {
          albumsByArtist[artistId] = albumResult.albums!;
        }
      });
    }

    return CombinedSearchResults(
      artists: artists,
      albumsByArtist: albumsByArtist,
    );
  }

  bool get isEmpty => artists.isEmpty && albumsByArtist.isEmpty;
  bool get isNotEmpty => !isEmpty;
}