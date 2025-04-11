import 'package:flutter/material.dart';
import 'app/my_app.dart';
import 'blocs/favorites_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesBloc.init(); // Initialiser Hive et le bloc de favoris
  runApp(MyApp());
}