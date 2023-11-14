import 'package:flutter/material.dart';

// const Color _shokutomoColor = Color.fromARGB(255, 252, 154, 94);
const Color _shokutomoColor = Color.fromARGB(255, 135, 198, 250);

const List<Color> colorThemes = [
  Colors.lightBlue,
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
  'lightBlue',
  'Red'
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
    
    final primarySwatch = MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    });

    return ThemeData(
      useMaterial3: true,
      // primarySwatch: primarySwatch,
      // primaryColor: colorThemes[selectedColor],
      colorSchemeSeed: primaryColor,
    
    );
  }
}