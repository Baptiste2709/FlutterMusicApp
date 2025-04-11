import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';
import 'artist_detail_screen.dart';
import 'album_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _artists = [];
  List<dynamic> _albums = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Charger des exemples initiaux à l'ouverture de l'écran
    _searchInitialExamples();
    
    // Ajouter un listener pour détecter les changements dans le champ de recherche
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _searchInitialExamples();
      }
    });
  }

  Future<void> _searchInitialExamples() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Rechercher "coldplay" car c'est supporté par l'API gratuite
      final artistResults = await ApiService.searchArtists('coldplay');
      final albumResults = await ApiService.searchAlbums('coldplay');
      
      if (mounted) {
        setState(() {
          _artists = artistResults;
          _albums = albumResults;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // En cas d'erreur, utiliser des données statiques
          _artists = [
            {
              'id': '111000',
              'name': 'Al Green',
              'imageUrl': 'https://theaudiodb.com/images/media/artist/thumb/al-green.jpg',
            },
            {
              'id': '111001',
              'name': 'Al Bano',
              'imageUrl': '',
            }
          ];

          _albums = [
            {
              'id': '222000',
              'title': 'Full of Fire',
              'artist': 'Al Green',
              'imageUrl': 'https://theaudiodb.com/images/media/album/thumb/full-of-fire.jpg',
            },
            {
              'id': '222001',
              'title': 'Great Hits',
              'artist': 'Al Green',
              'imageUrl': '',
            }
          ];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      _searchInitialExamples();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Effectuer une vraie recherche via l'API
      final artistResults = await ApiService.searchArtists(query);
      final albumResults = await ApiService.searchAlbums(query);
      
      if (mounted) {
        setState(() {
          _artists = artistResults;
          _albums = albumResults;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Afficher un message d'erreur ou gérer autrement
          print("Erreur de recherche: $e");
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchInitialExamples();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rechercher',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Céline Dion',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: _clearSearch,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
            ),
          ),
          _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          'Artistes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ..._artists.map((artist) => _buildArtistItem(
                        artist['name'],
                        artist['imageUrl'] ?? '',
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
                      ..._albums.map((album) => _buildAlbumItem(
                        album['title'],
                        album['artist'],
                        album['imageUrl'] ?? '',
                        album['id'],
                      )),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildArtistItem(String name, String imageUrl, String id) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('A', style: TextStyle(color: Colors.white)));
                },
              )
            : const Center(child: Text('A', style: TextStyle(color: Colors.white))),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Navigation vers les détails de l'artiste
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(
              artistId: id,
              artistName: name,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumItem(String title, String artist, String imageUrl, String id) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('A', style: TextStyle(color: Colors.white)));
                },
              )
            : const Center(child: Text('A', style: TextStyle(color: Colors.white))),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(artist, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Navigation vers les détails de l'album
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(
              albumId: id,
              albumName: title,
            ),
          ),
        );
      },
    );
  }
}