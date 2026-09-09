import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SelectProvider with ChangeNotifier {
  late Box settingBox;

  List<String> age = [
    '0-2 Years Old',
    '3-4 Years Old',
    '5-6 Years Old',
    '7-9 Years Old',
    '+9 years Old'
  ];
  List<String> favourite = [
    'Adventure',
    'Animal',
    'Family & Friends',
    'Science',
    'Mindfulness',
    'art',
  ];
  int isSelect = 0;
  int isSelectFavourite = 0;

  void selectedAge(int index) {
    isSelect = index;

    settingBox.put('selectedAgeIndex', index);
    notifyListeners();
  }

  void selectedFav(int index) {
    isSelectFavourite = index;
    settingBox.put('selectedFavIndex', index);
    notifyListeners();
  }
}
