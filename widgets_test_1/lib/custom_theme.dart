//* light themes -----------------------------------------------------------------------------------------------------------------------------------

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

var lightBaseColor = const Color.fromARGB(255, 16, 188, 0);
var darkTheme = false;

var _lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: lightBaseColor,
);

var lightTheme = ThemeData().copyWith(
  colorScheme: _lightColorScheme,
  textTheme: GoogleFonts.latoTextTheme(),
  cardTheme: const CardTheme().copyWith(
    color: _lightColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightColorScheme.primaryContainer,
    ),
  ),
);

//* theme provider -----------------------------------------------------------------------------------------------------------------------------------
//! the provider has only be used if a dynamic theming is intended

class ThemeProvider extends StateNotifier<ThemeData> {
  ThemeProvider()
      : super(lightTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            brightness: darkTheme ? Brightness.dark : Brightness.light,
            seedColor: lightBaseColor,
          ),
        ));
  bool darkMode = false;
  Color _seedColor = lightBaseColor;

  ///
  /// @brief updates the theme value depending on the newThemeColor and darkMode
  /// @param [newThemeColor] the new theme seed color that will be applied
  /// @param [darkMode] has to be set to apply either darkMode or lightMode
  /// @return void
  ///
  void updateThemeFromSeedColor(Color newThemeColor) {
    if (kDebugMode) {
      print('udpated theme');
    }
    var newTheme = lightTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        seedColor: newThemeColor,
      ),
    );

    _seedColor = newThemeColor;
    state = newTheme;
  }

  ///
  /// @brief updates the theme value depending on the newThemeColor and darkMode
  /// @param [darkMode] has to be set to apply either darkMode or lightMode
  /// @return void
  ///
  void toggleDarkMode(bool darkMode) {
    if (kDebugMode) {
      print('toggles the darkMode to $darkMode');
    }
    this.darkMode = darkMode;
    var newTheme = lightTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        seedColor: _seedColor,
      ),
    );
    state = newTheme;
  }

  Color get seedColor {
    return _seedColor;
  }
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeData>(
  (ref) => ThemeProvider(),
);
