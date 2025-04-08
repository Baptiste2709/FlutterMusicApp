class StringUtils {
  /// Vérifie si une chaîne est vide ou null
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }
  
  /// Vérifie si une chaîne n'est pas vide et pas null
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }
  
  /// Retourne une chaîne vide si la chaîne d'entrée est null
  static String safeString(String? str) {
    return str ?? '';
  }
  
  /// Tronque une chaîne à la longueur spécifiée et ajoute "..." si nécessaire
  static String truncate(String? text, int maxLength) {
    if (isEmpty(text) || text!.length <= maxLength) {
      return safeString(text);
    }
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Formate le nombre d'années (ex: "2010-2023")
  static String formatYearRange(String? startYear, String? endYear) {
    if (isEmpty(startYear)) return '';
    if (isEmpty(endYear) || startYear == endYear) return startYear!;
    return '$startYear-$endYear';
  }
  
  /// Formate une URL pour l'affichage
  static String formatUrl(String? url) {
    if (isEmpty(url)) return '';
    
    // Enlever le protocole
    String formatted = url!.replaceAll(RegExp(r'https?://'), '');
    
    // Enlever les slashes à la fin
    formatted = formatted.replaceAll(RegExp(r'/+$'), '');
    
    // Enlever "www."
    formatted = formatted.replaceAll('www.', '');
    
    return formatted;
  }
}