import 'package:flutter/material.dart';

class OnBoardingProvider with ChangeNotifier{
  final PageController _pageController = PageController();

  int currentIndex = 0;
  PageController get pageController=>_pageController;
  void changePage(int index){
    currentIndex=index;
    notifyListeners();

  }

}