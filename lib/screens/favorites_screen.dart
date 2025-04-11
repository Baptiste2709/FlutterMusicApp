import 'package:flutter/material.dart';
import '../blocs/favorites_bloc.dart';
import 'artist_detail_screen.dart';
import 'album_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoris',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: FavoritesBloc.favoritesNotifier,
        builder: (context, List<Map<String, dynamic>> favorites, _) {
          // Séparer les favoris en artistes et albums
          final artists = favorites.where((fav) => fav['type'] == 'artist').toList();
          final albums = favorites.where((fav) => fav['type'] == 'album').toList();

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun favori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des artistes ou albums à vos favoris',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              // Section Artistes
              if (artists.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Artistes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ...artists.map((artist) => _buildArtistTile(context, artist)),
              ],
              
              // Section Albums
              if (albums.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Albums',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ...albums.map((album) => _buildAlbumTile(context, album)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildArtistTile(BuildContext context, Map<String, dynamic> artist) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: artist['imageUrl'] != null && artist['imageUrl'].isNotEmpty
              ? Image.network(
                  artist['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        artist['name'].substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    artist['name'].substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
      title: Text(
        artist['name'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(
              artistId: artist['id'],
              artistName: artist['name'],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumTile(BuildContext context, Map<String, dynamic> album) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: album['imageUrl'] != null && album['imageUrl'].isNotEmpty
              ? Image.network(
                  album['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        album['title'].substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    album['title'].substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
      title: Text(
        album['title'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        album['artist'],
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(
              albumId: album['id'],
              albumName: album['title'],
            ),
          ),
        );
      },
    );
  }
}