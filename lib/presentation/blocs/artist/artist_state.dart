import 'package:equatable/equatable.dart';
import '../../../api/models/artist.dart';
import '../../../api/models/album.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();
  
  @override
  List<Object?> get props => [];
}

class ArtistInitialState extends ArtistState {}

class ArtistLoadingState extends ArtistState {}

class ArtistLoadedState extends ArtistState {
  final Artist artist;
  final List<Album> albums;
  
  const ArtistLoadedState({
    required this.artist,
    required this.albums,
  });
  
  @override
  List<Object> get props => [artist, albums];
}

class ArtistErrorState extends ArtistState {
  final String message;
  
  const ArtistErrorState({
    required this.message,
  });
  
  @override
  List<Object> get props => [message];
}