import 'package:flutter/material.dart';

// const Color _shokutomoColor = Color.fromARGB(255, 252, 154, 94);
const Color _shokutomoColor = Color.fromARGB(255, 135, 198, 250);

const List<Color> colorThemes = [
  _shokutomoColor,
  Color.fromARGB(255, 243, 227, 55),
  Color.fromARGB(255, 190, 53, 211),
  Color.fromARGB(255, 111, 49, 121),
  Color.fromARGB(255, 235, 102, 146),
  Color.fromARGB(255, 239, 198, 219),
  Color.fromARGB(255, 252, 154, 94),
  Color.fromARGB(255, 1, 86, 155),
  Color.fromARGB(255, 149, 221, 151), 
  Color.fromARGB(255, 253, 211, 172),
  Color.fromARGB(255, 170, 46, 87),
  Color.fromARGB(255, 197, 197, 197),
  Color.fromARGB(255, 32, 31, 31),
 
  
];
const List<String> colorNames = [
  'Shokutomo Color',
  'Yellow',
  'Purple',
  'Dark Purple',
  'Pink',
  'Pastel Pink',
  'Orange',
  'Dark Blue',
  'Matcha',
  'Beige',
  'Wine',
  'Grey',
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
      primarySwatch: primarySwatch,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        // primaryColorDark: primaryColor.withOpacity(0.8),
        accentColor: primaryColor,
        brightness: Brightness.light,
      ),
    
    );
  }
}