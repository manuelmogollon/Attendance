import 'package:flutter/material.dart';

ThemeData buildTheme() {
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      button: base.button.copyWith(
        fontFamily: 'Roboto',
        fontSize: 20.0,
        color: Colors.white,
      ),

      caption: base.caption.copyWith(
        fontSize: 20.0,
        fontFamily: "Roboto"),
    );
  }

  final ThemeData base = ThemeData.light();
  
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
  );
}