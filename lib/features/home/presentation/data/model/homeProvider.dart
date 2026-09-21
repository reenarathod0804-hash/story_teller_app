import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/widget/story_image.dart';

class HomeProvider with ChangeNotifier {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> stories = [];
  bool isLoading = true;

  Future<void> fetchCategoriesAndStoreInHive(BuildContext context) async {
    try {
      // Only show loading/shimmer if we have no cached data yet
      if (categories.isEmpty) {
        isLoading = true;
        notifyListeners();
      }

      var myBox = await Hive.openBox('categoriesBox');
      var langCode = Provider.of<ProfileProvider>(context, listen: false)
          .currentLocale
          .languageCode;

      var snapshot =
          await FirebaseFirestore.instance.collection('CategoryList').get();

      List<Map<String, dynamic>> loadedCategories = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        var nameMap = data['name'] is Map ? data['name'] as Map : {};
        var descMap = data['desc'] is Map ? data['desc'] as Map : {};

        var categoryData = {
          'id': doc.id,
          'name': nameMap[langCode] ?? nameMap['en'] ?? (data['name']?.toString() ?? ''),
          'desc': descMap[langCode] ?? descMap['en'] ?? (data['desc']?.toString() ?? ''),
        };

        await myBox.put(doc.id, categoryData);
        loadedCategories.add(categoryData);
      }

      if (loadedCategories.isNotEmpty) {
        categories = loadedCategories;
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      await getCategoriesFromHive();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCategoriesFromHive() async {
    try {
      var myBox = await Hive.openBox('categoriesBox');
      categories = myBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
      if (categories.isNotEmpty) {
        isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error reading categories from Hive: $e');
    }
  }

  Future<void> fetchStoriesAndStoreInHive(BuildContext context) async {
    try {
      var storyBox = await Hive.openBox('storiesBox');
      var langCode = Provider.of<ProfileProvider>(context, listen: false)
          .currentLocale
          .languageCode;

      var snapshot =
          await FirebaseFirestore.instance.collection('StoryList').get();

      List<Map<String, dynamic>> loadedStories = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        var nameMap = data['story_name'] is Map ? data['story_name'] as Map : {};
        var descMap = data['story_desc'] is Map ? data['story_desc'] as Map : {};

        String storyImage = (data['image']?.toString() ?? '').trim();
        if (storyImage.isEmpty) {
          storyImage = AppStoryImage.getImageForStory(doc.id);
        }

        var storyData = {
          'id': doc.id,
          'category_id': data['category_id'] ?? '',
          'story_name': nameMap[langCode] ?? nameMap['en'] ?? (data['story_name']?.toString() ?? ''),
          'story_desc': descMap[langCode] ?? descMap['en'] ?? (data['story_desc']?.toString() ?? ''),
          'image': storyImage,
        };

        await storyBox.put(doc.id, storyData);
        loadedStories.add(storyData);
      }

      if (loadedStories.isNotEmpty) {
        stories = loadedStories;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching stories: $e');
      await getStoriesFromHive();
    }
  }

  Future<void> getStoriesFromHive() async {
    try {
      var storyBox = await Hive.openBox('storiesBox');
      var rawStories = storyBox.values.cast<Map<String, dynamic>>().toList();
      List<Map<String, dynamic>> processed = [];
      for (var s in rawStories) {
        var map = Map<String, dynamic>.from(s);
        String img = (map['image']?.toString() ?? '').trim();
        if (img.isEmpty) {
          img = AppStoryImage.getImageForStory(map['id'] ?? map['story_name']);
          map['image'] = img;
        }
        processed.add(map);
      }
      stories = processed;
      notifyListeners();
    } catch (e) {
      debugPrint('Error reading stories from Hive: $e');
    }
  }
}

