// app_styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double margin = 16.0;
  static const double buttonPadding = 15.0;
  static const double iconSize = 24.0;

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static ButtonStyle elevatedButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: buttonPadding,
        horizontal: buttonPadding * 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}