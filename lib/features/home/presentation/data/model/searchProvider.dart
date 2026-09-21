import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';

class SearchProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> stories = [];
  List<Map<String, dynamic>> filteredCategories = [];
  List<Map<String, dynamic>> filteredStories = [];

  // Search history
  List<String> searchHistory = [];
  static const int _maxHistoryItems = 10;
  static const String _historyKey = 'search_history';

  String? selectedCat;

  SearchProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    var box = Hive.box('StoryBook');
    final saved = box.get(_historyKey);
    if (saved != null) {
      searchHistory = List<String>.from(saved);
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    var box = Hive.box('StoryBook');
    await box.put(_historyKey, searchHistory);
  }

  void addToHistory(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    // Remove duplicate if exists, then add to front
    searchHistory.remove(trimmed);
    searchHistory.insert(0, trimmed);
    // Keep only max items
    if (searchHistory.length > _maxHistoryItems) {
      searchHistory = searchHistory.sublist(0, _maxHistoryItems);
    }
    _saveHistory();
    notifyListeners();
  }

  void removeFromHistory(String query) {
    searchHistory.remove(query);
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    searchHistory.clear();
    _saveHistory();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    var box = await Hive.openBox('searchBox');
    var cached = box.get('categories');

    if (cached != null) {
      categories = List<Map<String, dynamic>>.from(
        cached.map((e) => Map<String, dynamic>.from(e)),
      );
    } else {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('CategoryList').get();
      categories = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      box.put('categories', categories);
    }

    filteredCategories = List.from(categories);
    notifyListeners();
  }

  Future<void> fetchStories() async {
    var box = await Hive.openBox('searchBox');
    var cached = box.get('stories');

    if (cached != null) {
      stories = List<Map<String, dynamic>>.from(
        cached.map((e) => Map<String, dynamic>.from(e)),
      );
    } else {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('StoryList').get();
      stories = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      box.put('stories', stories);
    }

    filteredStories = List.from(stories);
    notifyListeners();
  }

  void filterSearchResults(BuildContext context, String query) {
    final langCode = context.read<ProfileProvider>().currentLocale.languageCode;

    if (query.isEmpty) {
      filteredCategories = List.from(categories);
      filteredStories = List.from(stories);
      selectedCat = null;
    } else {
      final tempCategoryList = categories.where((cat) {
        final nameMap = cat['name'];
        final name = (nameMap is Map)
            ? (Map<String, dynamic>.from(nameMap))[langCode]?.toString().toLowerCase() ?? ''
            : '';
        return name.contains(query.toLowerCase());
      }).toList();

      final tempStoryList = stories.where((story) {
        final nameMap = story['story_name'];
        final name = (nameMap is Map)
            ? (Map<String, dynamic>.from(nameMap))[langCode]?.toString().toLowerCase() ?? ''
            : '';
        return name.contains(query.toLowerCase());
      }).toList();

      filteredCategories = tempCategoryList;
      filteredStories = tempStoryList;
    }

    notifyListeners();
  }


  void filterStoriesByCategory(String categoryId) {
    selectedCat = categoryId;
    filteredStories = stories.where((story) => story['category_id'] == selectedCat).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
