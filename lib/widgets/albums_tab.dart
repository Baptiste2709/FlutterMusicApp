import 'package:flutter/material.dart';
import '../models/album_model.dart';
import '../services/api_service.dart';
import '../constants/app_colors.dart';
import '../screens/album_detail_screen.dart';
import '../screens/artist_detail_screen.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({Key? key}) : super(key: key);

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  bool _isLoading = true;
  List<AlbumModel> _albums = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrendingAlbums();
  }

  Future<void> _loadTrendingAlbums() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final albums = await ApiService.getTrendingAlbums();
      
      if (mounted) {
        setState(() {
          _albums = albums;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les albums tendances';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTrendingAlbums,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_albums.isEmpty) {
      return const Center(
        child: Text('Aucun album tendance trouvé'),
      );
    }

    return ListView.builder(
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child: Text(
                    '${album.position}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: album.imageUrl.isNotEmpty
                        ? Image.network(
                            album.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.album, color: Colors.grey[600]);
                            },
                          )
                        : Icon(Icons.album, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            title: Text(
              album.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              album.artist,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              // Navigation vers les détails de l'album
              if (album.albumId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(
                      albumId: album.albumId,
                      albumName: album.title,
                    ),
                  ),
                );
              } else if (album.artistId.isNotEmpty) {
                // Si l'ID de l'album n'est pas disponible mais l'ID de l'artiste l'est
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistDetailScreen(
                      artistId: album.artistId,
                      artistName: album.artist,
                    ),
                  ),
                );
              } else {
                // Si aucun ID n'est disponible, effectuer une recherche
                _searchAndNavigateToAlbum(context, album.title, album.artist);
              }
            },
          ),
        );
      },
    );
  }
  
  // Méthode pour rechercher l'album et naviguer vers ses détails
  Future<void> _searchAndNavigateToAlbum(BuildContext context, String albumName, String artistName) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      
      final albums = await ApiService.searchAlbums(artistName);
      
      // Fermer l'indicateur de chargement
      Navigator.pop(context);
      
      // Chercher l'album correspondant
      Map<String, dynamic>? foundAlbum;
      for (var album in albums) {
        if (album['title'] == albumName) {
          foundAlbum = album;
          break;
        }
      }
      
      if (foundAlbum != null && foundAlbum['id'] != null) {
        // Naviguer vers les détails de l'album
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(
              albumId: foundAlbum?['id'],
              albumName: albumName,
            ),
          ),
        );
      } else {
        // Si l'album n'est pas trouvé, essayer de naviguer vers l'artiste
        final artists = await ApiService.searchArtists(artistName);
        
        if (artists.isNotEmpty && artists[0]['id'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailScreen(
                artistId: artists[0]['id'],
                artistName: artistName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de trouver cet album ou artiste'),
            ),
          );
        }
      }
    } catch (e) {
      // Fermer l'indicateur de chargement en cas d'erreur
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
        ),
      );
    }
  }
}