import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/album_model.dart';
import 'album_detail_screen.dart';
import '../blocs/favorites_bloc.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistDetailScreen({
    Key? key,
    required this.artistId,
    required this.artistName,
  }) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  Map<String, dynamic>? _artistDetail;
  List<AlbumModel> _albums = [];
  bool _isLoading = true;
  bool _isError = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadArtistDetails();
    _checkIfFavorite();
  }

  Future<void> _loadArtistDetails() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Charger les détails de l'artiste
      final artistData = await ApiService.getArtistDetails(widget.artistId);
      // Charger les albums de l'artiste
      final albumsData = await ApiService.getArtistAlbums(widget.artistId);
      
      if (mounted) {
        setState(() {
          _artistDetail = artistData;
          _albums = albumsData;
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
      print('Erreur lors du chargement des détails de l\'artiste: $e');
    }
  }

  void _checkIfFavorite() async {
    final isFav = await FavoritesBloc.isArtistFavorite(widget.artistId);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesBloc.removeArtistFromFavorites(widget.artistId);
    } else {
      if (_artistDetail != null) {
        await FavoritesBloc.addArtistToFavorites({
          'id': widget.artistId,
          'name': _artistDetail!['strArtist'] ?? widget.artistName,
          'imageUrl': _artistDetail!['strArtistThumb'] ?? '',
          'type': 'artist',
        });
      }
    }
    
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _isError 
              ? _buildErrorView()
              : _buildArtistDetailView(),
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
            onPressed: _loadArtistDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistDetailView() {
    if (_artistDetail == null) return const Center(child: Text('Aucune information disponible'));
    
    // Obtenir la biographie dans la langue de l'utilisateur ou en anglais par défaut
    String biography = _artistDetail!['strBiographyFR'] ?? 
                       _artistDetail!['strBiographyEN'] ?? 
                       'Aucune biographie disponible';
                       
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations générales
                Row(
                  children: [
                    Text(
                      _artistDetail!['strArtist'] ?? widget.artistName,
                      style: const TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Spacer(),
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
                const SizedBox(height: 8),
                
                // Détails de l'artiste
                if (_artistDetail!['strGenre'] != null)
                  _buildInfoRow('Genre', _artistDetail!['strGenre']),
                if (_artistDetail!['strCountry'] != null)
                  _buildInfoRow('Pays', _artistDetail!['strCountry']),
                if (_artistDetail!['intFormedYear'] != null)
                  _buildInfoRow('Formé en', _artistDetail!['intFormedYear']),
                
                const SizedBox(height: 16),
                
                // Biographie
                const Text(
                  'Biographie',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(biography),
                
                const SizedBox(height: 24),
                
                // Albums
                const Text(
                  'Albums',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        // Liste des albums
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final album = _albums[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: album.imageUrl.isNotEmpty
                      ? Image.network(
                          album.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('A', style: TextStyle(color: Colors.white)));
                          },
                        )
                      : const Center(child: Text('A', style: TextStyle(color: Colors.white))),
                  ),
                ),
                title: Text(
                  album.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumDetailScreen(
                        albumId: album.position.toString(),
                        albumName: album.title,
                      ),
                    ),
                  );
                },
              );
            },
            childCount: _albums.length,
          ),
        ),
        
        // Espacement en bas
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: _artistDetail!['strArtistWideThumb'] != null
            ? Image.network(
                _artistDetail!['strArtistWideThumb'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        _artistDetail!['strArtist']?.substring(0, 1) ?? 'A',
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
            : _artistDetail!['strArtistThumb'] != null
                ? Image.network(
                    _artistDetail!['strArtistThumb'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            _artistDetail!['strArtist']?.substring(0, 1) ?? 'A',
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
                        _artistDetail!['strArtist']?.substring(0, 1) ?? 'A',
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