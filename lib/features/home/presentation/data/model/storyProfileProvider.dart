import 'package:flutter/cupertino.dart';

class StoryProfileProvider with ChangeNotifier{
  bool isNotification = false;
  void changeNotification(value){
    isNotification=value;
    notifyListeners();
  }
}