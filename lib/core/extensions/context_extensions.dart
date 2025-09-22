import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // ColorScheme shortcuts
  ColorScheme get cs => Theme.of(this).colorScheme;
  
  // Text Theme shortcuts  
  TextTheme get textTheme => Theme.of(this).textTheme;
}