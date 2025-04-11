import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/singles_list.dart';
import '../widgets/albums_tab.dart';
import '../screens/search_screen.dart';
import '../screens/favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Écouter les changements d'onglets
    _tabController.addListener(() {
      setState(() {});
    });
    
    // Le chargement des données est géré par les widgets individuels
    // Pour garder l'interface réactive
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Classements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_selectedIndex == 0) {
      // AppBar pour l'onglet Classements
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Classements',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro',
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'SF Pro',
          ),
          tabs: const [
            Tab(text: 'Titres'),
            Tab(text: 'Albums'),
          ],
        ),
      );
    }
    // Pour les autres onglets, l'AppBar est géré par leurs écrans respectifs
    return null;
  }
  
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        // Onglet Classements
        return TabBarView(
          controller: _tabController,
          children: [
            // Onglet Titres
            _isLoading 
              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
              : const SinglesList(),
            // Onglet Albums
            const AlbumsTab(),
          ],
        );
      case 1:
        // Onglet Recherche
        return const SearchScreen();
      case 2:
        // Onglet Favoris
        return const FavoritesScreen();
      default:
        return const Center(child: Text('Page introuvable'));
    }
  }
}