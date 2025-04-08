import 'package:flutter/material.dart';

/// Constantes liées au design de l'application
class DesignConstants {
  // Espacements
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // Rayons
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;
  
  // Taille des icons
  static const double iconSizeXS = 12.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  // Animations
  static const Duration animationDurationShort = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  // Dimensions des éléments UI
  static const double cardHeight = 100.0;
  static const double albumThumbSize = 80.0;
  static const double artistThumbSize = 80.0;
  static const double bannerHeight = 200.0;
  
  // Tailles d'images
  static const double albumCardWidth = 140.0;
  static const double albumImageHeight = 140.0;
  
  // Élévations
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationLarge = 4.0;
  
  // Marges d'écran
  static const EdgeInsets screenPadding = EdgeInsets.all(spaceM);
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceM);
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    vertical: spaceS,
    horizontal: spaceM,
  );
  
  // Étendre à votre convenance avec d'autres constantes de design
}