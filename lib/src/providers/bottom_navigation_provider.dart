import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum Navigations { Home, Schedule, Todo, Diary }

class BottomNavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get currentPage => _index;

  updateCurrentPage(
    int index,
  ) {
    _index = index;
    notifyListeners();
  }
}
