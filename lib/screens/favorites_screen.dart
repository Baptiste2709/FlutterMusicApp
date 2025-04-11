import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Données fictives pour les favoris (à remplacer par une vraie implémentation avec Hive/Isar)
  final List<Map<String, dynamic>> favoriteArtists = [];
  final List<Map<String, dynamic>> favoriteAlbums = [];

  @override
  void initState() {
    super.initState();
    // Charger les favoris depuis la persistance
    _loadFavorites();
  }

  void _loadFavorites() {
    // Dans une vraie implémentation, charger les favoris depuis Hive/Isar
    // Pour l'instant, juste des données de test
    setState(() {
      favoriteArtists.add({
        'id': '112024',
        'name': 'Al Green',
        'imageUrl': 'https://theaudiodb.com/images/media/artist/thumb/al-green.jpg',
      });
      
      favoriteArtists.add({
        'id': '113051',
        'name': 'Al Bano',
        'imageUrl': 'https://theaudiodb.com/images/media/artist/thumb/al-bano.jpg',
      });
      
      favoriteAlbums.add({
        'id': '2115888',
        'title': 'Full of Fire',
        'artist': 'Al Green',
        'imageUrl': 'https://theaudiodb.com/images/media/album/thumb/full-of-fire.jpg',
      });
      
      favoriteAlbums.add({
        'id': '2115889',
        'title': 'Great Hits',
        'artist': 'Al Green',
        'imageUrl': 'https://theaudiodb.com/images/media/album/thumb/great-hits.jpg',
      });
    });
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Artistes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Liste des artistes favoris
            ...favoriteArtists.map((artist) => _buildArtistItem(
                  artist['name'],
                  artist['imageUrl'],
                  artist['id'],
                )),
            
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Albums',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Liste des albums favoris
            ...favoriteAlbums.map((album) => _buildAlbumItem(
                  album['title'],
                  album['artist'],
                  album['imageUrl'],
                  album['id'],
                )),
            
            // Message si aucun favori
            if (favoriteArtists.isEmpty && favoriteAlbums.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Vous n\'avez pas encore ajouté de favoris.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistItem(String name, String imageUrl, String id) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              )
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigation vers les détails de l'artiste avec l'ID
      },
    );
  }

  Widget _buildAlbumItem(String title, String artist, String imageUrl, String id) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.album, color: Colors.grey),
                  );
                },
              )
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.album, color: Colors.grey),
              ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(artist),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigation vers les détails de l'album avec l'ID
      },
    );
  }
}