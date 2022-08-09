import 'package:flutter/material.dart';

class StatusProvider extends ChangeNotifier {

  bool _isProgress = false;

 int curIndex = 0;

 int get currentIndex => curIndex;

  setCurrentIndex(int currIndex) {
    curIndex = currIndex;
    notifyListeners();
  }
}
