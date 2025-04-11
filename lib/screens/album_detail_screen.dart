import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAlbumDetails();
  }

  Future<void> _loadAlbumDetails() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Charger les détails de l'album
      final albumData = await ApiService.getAlbumDetails(widget.albumId);
      
      if (mounted) {
        setState(() {
          _albumDetail = albumData;
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
                         'Aucune description disponible';
                         
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
                Text(
                  _albumDetail!['strAlbum'] ?? widget.albumName,
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold
                  ),
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
                
                // Détails de l'album
                if (_albumDetail!['strGenre'] != null)
                  _buildInfoRow('Genre', _albumDetail!['strGenre']),
                if (_albumDetail!['intYearReleased'] != null)
                  _buildInfoRow('Année', _albumDetail!['intYearReleased']),
                if (_albumDetail!['strLabel'] != null)
                  _buildInfoRow('Label', _albumDetail!['strLabel']),
                
                const SizedBox(height: 24),
                
                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(description),
                
                const SizedBox(height: 16),
                
                // Titres les plus populaires (simulé car l'API gratuite ne fournit pas les titres)
                const Text(
                  'Titres les plus appréciés',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                // Liste de faux titres pour la démo
                _buildMockTracksList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockTracksList() {
    // Simuler une liste de titres pour la démo
    final trackNames = [
      'Track 1 (feat. Another Artist)',
      'Track 2',
      'Track 3 feat. Someone',
      'Track 4',
      'Track 5 (Remix)',
      'Track 6',
      'Track 7'
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          title: Text(trackNames[index]),
          trailing: const Icon(Icons.more_vert),
        );
      },
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