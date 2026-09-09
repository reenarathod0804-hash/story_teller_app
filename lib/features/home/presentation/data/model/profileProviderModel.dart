
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:story_teller/core/service/notification_service.dart';
import 'homeProvider.dart';

class ProfileProvider with ChangeNotifier {
  late Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  int? tempSelectedIndex;

  ProfileProvider() {
    loadSavedLocale();
  }


  var nameBox = Hive.box('StoryBook');
  List<String> image = [
    'assets/images/png/update1.png',
    'assets/images/png/update2.png',
    'assets/images/png/update3.png',
  ];

  String? _imageURL;

  String? get imageURL => _imageURL;

  TextEditingController textEditingController = TextEditingController();
  List<String> names = ['English', 'Hindi', 'Spanish'];
  int? isChecked = 0;
  bool isNotification = true;
  late String check = 'English';

  void changeNot(bool value) {
    isNotification = value;
    nameBox.put('notification', value);
    if (value) {
      NotificationService.subscribeToNewStories();
    } else {
      NotificationService.unsubscribeFromNewStories();
    }
    notifyListeners();
  }

  void changeImage(String? value) {
    _imageURL = value;
    nameBox.put('images', value);
    notifyListeners();
  }

  void setImage(String? value) {
    _imageURL = value;
  }

  void saveName(String name) {
    nameBox.put('username', name);
    notifyListeners();
  }

  void savedLang(int index) {
    tempSelectedIndex = index;
    notifyListeners();
  }

  Future<void> saveLang(String name, int index, BuildContext context) async {
    check = name;
    isChecked = index;

    nameBox.put('language', name);
    nameBox.put('selectedLanguage', index);

    String langCode = 'en';
    if (name == 'Hindi') langCode = 'hi';
    if (name == 'Spanish') langCode = 'es';

    nameBox.put('languageCode', langCode);
    _currentLocale = Locale(langCode);

    notifyListeners();

    Hive.box('categoriesBox').clear();
    Hive.box('storiesBox').clear();

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.fetchCategoriesAndStoreInHive(context);
    homeProvider.fetchStoriesAndStoreInHive(context);
  }

  void loadSavedLocale() {
    String langCode = nameBox.get('languageCode', defaultValue: 'en');
    _currentLocale = Locale(langCode);
    notifyListeners();
  }
}
