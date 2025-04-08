import 'package:equatable/equatable.dart';
import '../../../api/models/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();
  
  @override
  List<Object?> get props => [];
}

class AlbumInitialState extends AlbumState {}

class AlbumLoadingState extends AlbumState {}

class AlbumLoadedState extends AlbumState {
  final Album album;
  
  const AlbumLoadedState({
    required this.album,
  });
  
  @override
  List<Object> get props => [album];
}

class AlbumErrorState extends AlbumState {
  final String message;
  
  const AlbumErrorState({
    required this.message,
  });
  
  @override
  List<Object> get props => [message];
}