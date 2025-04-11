import 'package:flutter/material.dart';
import '../models/single_model.dart';
import '../services/api_service.dart';
import '../constants/app_colors.dart';
import '../screens/artist_detail_screen.dart';

class SinglesList extends StatefulWidget {
  const SinglesList({Key? key}) : super(key: key);

  @override
  State<SinglesList> createState() => _SinglesListState();
}

class _SinglesListState extends State<SinglesList> {
  bool _isLoading = true;
  List<SingleModel> _singles = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrendingSingles();
  }

  Future<void> _loadTrendingSingles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final singles = await ApiService.getTrendingSingles();
      
      if (mounted) {
        setState(() {
          _singles = singles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les singles tendances';
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
              onPressed: _loadTrendingSingles,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_singles.isEmpty) {
      return const Center(
        child: Text('Aucun single tendance trouvé'),
      );
    }

    return ListView.builder(
      itemCount: _singles.length,
      itemBuilder: (context, index) {
        final single = _singles[index];
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
                    '${single.position}',
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
                    child: single.imageUrl.isNotEmpty
                        ? Image.network(
                            single.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.music_note, color: Colors.grey[600]);
                            },
                          )
                        : Icon(Icons.music_note, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            title: Text(
              single.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              single.artist,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              if (single.artistId.isNotEmpty) {
                // Navigation vers les détails de l'artiste avec l'ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistDetailScreen(
                      artistId: single.artistId,
                      artistName: single.artist,
                    ),
                  ),
                );
              } else {
                // Si l'ID n'est pas disponible, afficher un message d'erreur
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Impossible d\'accéder aux détails de cet artiste'),
                  ),
                );
                
                // Alternativement, effectuer une recherche à la volée
                _searchAndNavigateToArtist(context, single.artist);
              }
            },
          ),
        );
      },
    );
  }
  
  // Méthode pour rechercher l'artiste et naviguer vers ses détails
  Future<void> _searchAndNavigateToArtist(BuildContext context, String artistName) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      
      final artists = await ApiService.searchArtists(artistName);
      
      // Fermer l'indicateur de chargement
      Navigator.pop(context);
      
      if (artists.isNotEmpty && artists[0]['id'] != null) {
        // Naviguer vers les détails de l'artiste
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
            content: Text('Impossible de trouver cet artiste'),
          ),
        );
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