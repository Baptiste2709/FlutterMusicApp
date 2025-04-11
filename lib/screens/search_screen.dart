import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Charger des suggestions au démarrage
    _loadInitialSuggestions();
  }

  Future<void> _loadInitialSuggestions() async {
    try {
      final suggestions = await Future.wait([
        ApiService.searchArtists('al'),
        ApiService.searchAlbums('greatest')
      ]);
      
      if (mounted) {
        setState(() {
          _searchResults = [...suggestions[0].take(2), ...suggestions[1].take(2)];
        });
      }
    } catch (e) {
      // Ignorer les erreurs lors du chargement des suggestions
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _hasSearched = false;
        _isSearching = false;
        _errorMessage = null;
      });
      return;
    }

    // Attendre que l'utilisateur ait fini de taper
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      final results = await Future.wait([
        ApiService.searchArtists(query),
        ApiService.searchAlbums(query)
      ]);
      
      if (mounted) {
        setState(() {
          _searchResults = [...results[0], ...results[1]];
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Une erreur est survenue lors de la recherche';
          _isSearching = false;
        });
      }
    }
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
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
            ),
          ),
          if (_isSearching)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _performSearch(_searchController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          else if (_hasSearched && _searchResults.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Aucun résultat trouvé'),
              ),
            )
          else
            _buildResults(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    // Séparer les résultats par type
    final artists = _searchResults
        .where((item) => item['type'] == 'artist')
        .toList();
    
    final albums = _searchResults
        .where((item) => item['type'] == 'album')
        .toList();
    
    if (artists.isEmpty && albums.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('Effectuez une recherche pour voir les résultats'),
        ),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artists.isNotEmpty) ...[
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
              ...artists.map((artist) => _buildArtistItem(
                    artist['name'] ?? 'Artiste inconnu',
                    artist['imageUrl'] ?? '',
                    artist['id'] ?? '',
                  )),
            ],
            if (albums.isNotEmpty) ...[
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
              ...albums.map((album) => _buildAlbumItem(
                    album['title'] ?? 'Album inconnu',
                    album['artist'] ?? 'Artiste inconnu',
                    album['imageUrl'] ?? '',
                    album['id'] ?? '',
                  )),
            ],
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
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigation vers les détails de l'artiste avec l'ID
        debugPrint('Navigate to artist details: $id');
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
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        artist,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigation vers les détails de l'album avec l'ID
        debugPrint('Navigate to album details: $id');
      },
    );
  }
}