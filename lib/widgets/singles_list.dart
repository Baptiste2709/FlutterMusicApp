import 'package:flutter/material.dart';
import '../models/single_model.dart';
import '../services/api_service.dart';
import '../constants/app_colors.dart';

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
              // Navigation vers les détails de la chanson/artiste
            },
          ),
        );
      },
    );
  }
}