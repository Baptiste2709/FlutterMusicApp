import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchTestScreen extends StatefulWidget {
  const SearchTestScreen({Key? key}) : super(key: key);

  @override
  State<SearchTestScreen> createState() => _SearchTestScreenState();
}

class _SearchTestScreenState extends State<SearchTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchArtist() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez entrer un nom d'artiste";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Utiliser l'API pour rechercher un artiste
      final results = await ApiService.searchArtists(query);
      
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      
      if (results.isEmpty) {
        setState(() {
          _errorMessage = "Aucun résultat trouvé pour '$query'";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de recherche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Nom d'artiste",
                hintText: "Essayez 'coldplay'",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchArtist,
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Rechercher'),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text("Les résultats apparaîtront ici"),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final artist = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (artist['imageUrl']?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: Image.network(
                        artist['imageUrl'],
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                Text(
                  'Nom: ${artist['name']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('ID: ${artist['id']}'),
                if (artist['genre']?.isNotEmpty ?? false)
                  Text('Genre: ${artist['genre']}'),
                if (artist['country']?.isNotEmpty ?? false)
                  Text('Pays: ${artist['country']}'),
                if (artist['description']?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    artist['description'],
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextButton(
                    onPressed: () {
                      // Afficher la description complète
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('À propos de ${artist['name']}'),
                          content: SingleChildScrollView(
                            child: Text(artist['description']),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Lire plus'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}