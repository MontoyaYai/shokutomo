import 'package:flutter/material.dart';

// const Color _shokutomoColor = Color.fromARGB(255, 252, 154, 94);
const Color _shokutomoColor = Color.fromARGB(255, 135, 198, 250);

const List<Color> colorThemes = [
  Colors.lightBlue,
  Colors.red,
  Colors.yellow,
  Colors.purple,
  Colors.pinkAccent,
  Colors.pink,
  Colors.orange,
  Colors.green,
  Colors.grey,
  Colors.lime,
  Colors.black
];
const List<String> colorNames = [
  'Shokutomo Color',
  'Red',
  'Yellow',
  'Purple',
  'PinkAccent',
  'Pink',
  'Orange',
  'Green',
  'Grey',
  'Lime',
  'Black',
];
class AppTheme with ChangeNotifier {
  int _selectedColor;

  AppTheme({int selectedColor = 0}) : _selectedColor = selectedColor;

  int get selectedColor => _selectedColor;

  set selectedColor(int value) {
    _selectedColor = value;
    notifyListeners();
  }

  ThemeData theme() {
    final primaryColor = colorThemes[selectedColor];

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
    );
  }
}
