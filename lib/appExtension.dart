import 'package:flutter/material.dart';
import 'package:story_teller/appLocalization.dart';

extension LocalizationExtension on BuildContext {
  String t(String key) {
    return LocalizationService.of(this).translate(key);
  }
}
