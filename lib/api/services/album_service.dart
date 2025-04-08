import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/album.dart';
import '../models/search_result.dart';
import '../../core/constants/api_constants.dart';

part 'album_service.g.dart';

@RestApi()
abstract class AlbumService {
  factory AlbumService(Dio dio, {String baseUrl}) = _AlbumService;
  
  /// Récupère les détails d'un album par son ID
  @GET('/album.php')
  Future<AlbumResponse> getAlbumById({
    @Query('i') required String albumId,
  });
  
  /// Récupère tous les albums d'un artiste par son ID
  @GET('/album.php')
  Future<AlbumResponse> getArtistAlbums({
    @Query('i') required String artistId,
  });
  
  /// Recherche des albums par nom
  @GET('/searchalbum.php')
  Future<SearchAlbumResult> searchAlbums({
    @Query('s') required String albumName,
  });
}