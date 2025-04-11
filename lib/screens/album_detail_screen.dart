import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'track_lyrics_screen.dart';
import '../blocs/favorites_bloc.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;
  final String albumName;

  const AlbumDetailScreen({
    Key? key,
    required this.albumId,
    required this.albumName,
  }) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  Map<String, dynamic>? _albumDetail;
  bool _isLoading = true;
  bool _isError = false;
  List<Map<String, dynamic>> _tracks = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadAlbumDetails();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await FavoritesBloc.isAlbumFavorite(widget.albumId);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesBloc.removeAlbumFromFavorites(widget.albumId);
    } else {
      if (_albumDetail != null) {
        await FavoritesBloc.addAlbumToFavorites({
          'id': widget.albumId,
          'title': _albumDetail!['strAlbum'] ?? widget.albumName,
          'artist': _albumDetail!['strArtist'] ?? 'Artiste inconnu',
          'imageUrl': _albumDetail!['strAlbumThumb'] ?? '',
          'type': 'album',
        });
      }
    }
    
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _loadAlbumDetails() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Charger les détails de l'album
      final albumData = await ApiService.getAlbumDetails(widget.albumId);
      
      // Simuler des titres pour l'album
      final mockTracks = [
        {
          'id': '1',
          'title': 'Walk on Water feat. Beyoncé',
          'duration': '5:03',
          'featuring': 'Beyoncé'
        },
        {
          'id': '2',
          'title': 'Believe',
          'duration': '4:25',
          'featuring': ''
        },
        {
          'id': '3',
          'title': 'Chloraseptic feat. Phresher',
          'duration': '5:30',
          'featuring': 'Phresher'
        },
        {
          'id': '4',
          'title': 'Untouchable',
          'duration': '6:10',
          'featuring': ''
        },
        {
          'id': '5',
          'title': 'River feat. Ed Sheeran',
          'duration': '3:41',
          'featuring': 'Ed Sheeran'
        },
        {
          'id': '6',
          'title': 'Remind Me (Intro)',
          'duration': '3:16',
          'featuring': ''
        },
        {
          'id': '7',
          'title': 'Revival',
          'duration': '5:08',
          'featuring': ''
        },
      ];
      
      if (mounted) {
        setState(() {
          _albumDetail = albumData;
          _tracks = mockTracks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
      print('Erreur lors du chargement des détails de l\'album: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _isError 
              ? _buildErrorView()
              : _buildAlbumDetailView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Une erreur est survenue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAlbumDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumDetailView() {
    if (_albumDetail == null) return const Center(child: Text('Aucune information disponible'));
    
    // Obtenir la description dans la langue de l'utilisateur ou en anglais par défaut
    String description = _albumDetail!['strDescriptionFR'] ?? 
                         _albumDetail!['strDescriptionEN'] ?? 
                         'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s. When an unknown printer took a copy of type and scrambled it to make.';
                         
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de l'album
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _albumDetail!['strAlbum'] ?? widget.albumName,
                        style: const TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Artiste
                Text(
                  _albumDetail!['strArtist'] ?? 'Artiste inconnu',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Statistiques de l'album
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      _buildStatItem('342', 'ventes'),
                      const SizedBox(width: 32),
                      _buildStatItem('17', 'streams'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Section Titres
                const Text(
                  'Titres',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Liste des titres
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final track = _tracks[index];
              return ListTile(
                leading: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                title: Text(
                  track['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.more_vert, color: Colors.grey),
                onTap: () {
                  // Navigation vers l'écran des paroles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackLyricsScreen(
                        trackId: track['id'],
                        trackTitle: track['title'],
                        artistName: _albumDetail!['strArtist'] ?? 'Artiste inconnu',
                        featuring: track['featuring'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
            childCount: _tracks.length,
          ),
        ),
        
        // Espacement en bas
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: _albumDetail!['strAlbumThumb'] != null
            ? Image.network(
                _albumDetail!['strAlbumThumb'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        _albumDetail!['strAlbum']?.substring(0, 1) ?? 'A',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    _albumDetail!['strAlbum']?.substring(0, 1) ?? 'A',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}