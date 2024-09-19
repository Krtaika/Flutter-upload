
class UserPreferences {
  List<String> likedStyles = [];
  List<String> pastPurchases = [];

  void addLikedStyle(String style) {
    likedStyles.add(style);
  }

  void addPastPurchase(String item) {
    pastPurchases.add(item);
  }

  List<String> recommendItems() {
    // Example recommendation logic based on liked styles
    // In real-world scenarios, this would be more sophisticated
    return likedStyles.map((style) => 'Recommended item for $style').toList();
  }
}