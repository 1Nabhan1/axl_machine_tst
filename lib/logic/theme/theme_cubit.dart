import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeBox = 'settings';
  static const _themeKey = 'theme_mode';

  final Box _box;

  ThemeCubit(this._box) : super(ThemeMode.light) {
    // Load saved theme on start
    final saved = _box.get(_themeKey);
    if (saved != null) {
      emit(saved == 'dark' ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void toggleTheme() {
    final newMode =
    state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);

    // Save locally
    _box.put(_themeKey, newMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
