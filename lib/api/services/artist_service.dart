import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/artist.dart';
import '../models/search_result.dart';
import '../../core/constants/api_constants.dart';

part 'artist_service.g.dart';

@RestApi()
abstract class ArtistService {
  factory ArtistService(Dio dio, {String baseUrl}) = _ArtistService;
  
  /// Récupère les détails d'un artiste par son ID
  @GET('/artist.php')
  Future<ArtistResponse> getArtistById({
    @Query('i') required String artistId,
  });
  
  /// Recherche des artistes par nom
  @GET('/search.php')
  Future<SearchArtistResult> searchArtists({
    @Query('s') required String artistName,
  });
}