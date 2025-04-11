import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/album_model.dart';
import 'album_detail_screen.dart';
import 'track_lyrics_screen.dart';
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

class _ArtistDetailScreenState extends State<ArtistDetailScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _artistDetail;
  List<AlbumModel> _albums = [];
  bool _isLoading = true;
  bool _isError = false;
  bool _isFavorite = false;
  late TabController _tabController;
  
  // Titres populaires simulés
  final List<Map<String, dynamic>> _popularTracks = [
    {'title': 'Walk on Water feat. Beyoncé', 'id': '1'},
    {'title': 'Believe', 'id': '2'},
    {'title': 'Chloraseptic feat. Phresher', 'id': '3'},
    {'title': 'Untouchable', 'id': '4'},
    {'title': 'River feat. Ed Sheeran', 'id': '5'},
    {'title': 'Remind Me (Intro)', 'id': '6'},
    {'title': 'Revival', 'id': '7'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadArtistDetails();
    _checkIfFavorite();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          
          // En cas d'erreur, simuler quelques données
          _artistDetail = {
            'strArtist': 'Eminem',
            'strArtistThumb': 'https://www.theaudiodb.com/images/media/artist/thumb/eminem.jpg',
            'strGenre': 'Hip Hop',
            'strCountry': 'USA',
            'intFormedYear': '1996',
            'strBiographyEN': 'Eminem, born Marshall Bruce Mathers III, is an American rapper, songwriter, and record producer. Eminem is among the best-selling music artists of all time, with estimated worldwide sales of over 220 million records.'
          };
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
          : _isError && _artistDetail == null
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
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information de l'artiste en tête
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et bouton favori
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _artistDetail!['strArtist'] ?? widget.artistName,
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
                    
                    // Détails de l'artiste
                    if (_artistDetail!['strGenre'] != null)
                      _buildInfoRow('Genre', _artistDetail!['strGenre']),
                    if (_artistDetail!['strCountry'] != null)
                      _buildInfoRow('Pays', _artistDetail!['strCountry']),
                    if (_artistDetail!['intFormedYear'] != null)
                      _buildInfoRow('Actif depuis', _artistDetail!['intFormedYear']),
                  ],
                ),
              ),
              
              // Onglets
              TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                tabs: const [
                  Tab(text: 'Albums'),
                  Tab(text: 'Titres populaires'),
                ],
              ),
            ],
          ),
        ),
        
        // Contenu des onglets
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Onglet Albums
              _buildAlbumsTab(),
              
              // Onglet Titres populaires
              _buildPopularTracksTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumsTab() {
  // Si on n'a pas d'albums, on affiche des albums simulés
  final albumsToShow = _albums.isNotEmpty 
      ? _albums 
      : [
          AlbumModel(
            position: 1, 
            title: 'Revival', 
            artist: _artistDetail!['strArtist'] ?? widget.artistName, 
            imageUrl: '',
            albumId: '11111', // ID simulé pour l'album
            artistId: widget.artistId, // Utiliser l'ID de l'artiste actuel
          ),
          AlbumModel(
            position: 2, 
            title: 'Star Boy', 
            artist: _artistDetail!['strArtist'] ?? widget.artistName, 
            imageUrl: '',
            albumId: '22222', // ID simulé pour l'album
            artistId: widget.artistId, // Utiliser l'ID de l'artiste actuel
          ),
          AlbumModel(
            position: 3, 
            title: 'Beauty Behind the Madness', 
            artist: _artistDetail!['strArtist'] ?? widget.artistName, 
            imageUrl: '',
            albumId: '33333', // ID simulé pour l'album
            artistId: widget.artistId, // Utiliser l'ID de l'artiste actuel
          ),
        ];
        
  return ListView.builder(
    padding: const EdgeInsets.all(0),
    itemCount: albumsToShow.length,
    itemBuilder: (context, index) {
      final album = albumsToShow[index];
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
                albumId: album.albumId, // Utiliser l'ID de l'album
                albumName: album.title,
              ),
            ),
          );
        },
      );
    },
  );
}
  Widget _buildPopularTracksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: _popularTracks.length,
      itemBuilder: (context, index) {
        final track = _popularTracks[index];
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
            // Naviguer vers l'écran des paroles
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackLyricsScreen(
                  trackId: track['id'],
                  trackTitle: track['title'],
                  artistName: _artistDetail!['strArtist'] ?? widget.artistName,
                  featuring: track['title'].contains('feat.') 
                      ? track['title'].split('feat.')[1].trim() 
                      : '',
                ),
              ),
            );
          },
        );
      },
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