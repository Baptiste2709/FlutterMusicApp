import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../../presentation/blocs/favorites/favorites_event.dart';
import '../../../presentation/screens/home/tabs/charts_tab.dart';
import '../../../presentation/screens/home/tabs/search_tab.dart';
import '../../../presentation/screens/home/tabs/favorites_tab.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;
  
  const HomeScreen({
    Key? key, 
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize the tab controller with the specified initial tab
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    // Load favorites data when the screen is initialized
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Music App',
          style: AppTextStyles.h3,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.tabLabel,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Classements'),
            Tab(text: 'Recherche'),
            Tab(text: 'Favoris'),
          ],
          onTap: (index) {
            // Update URL if using GoRouter deep linking
            switch (index) {
              case 0:
                context.go('/charts');
                break;
              case 1:
                context.go('/search');
                break;
              case 2:
                context.go('/favorites');
                break;
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChartsTab(),
          SearchTab(),
          FavoritesTab(),
        ],
      ),
    );
  }
}