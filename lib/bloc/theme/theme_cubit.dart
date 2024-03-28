import 'dart:developer';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rhymer/repo/settings/settings.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required SettingsRepoInterface settingsRepo,
  })  : _settingsRepo = settingsRepo,
        super(const ThemeState(Brightness.light)) {
    _checkSelectedTheme();
  }

  final SettingsRepoInterface _settingsRepo;

  Future<void> setBrightness(Brightness brightness) async {
    try {
      emit(ThemeState(brightness));
      _settingsRepo.setDarkThemeSelected(brightness == Brightness.dark);
    } catch (e) {
      log(e.toString());
    }
  }

  void _checkSelectedTheme() {
    try {
      final brightness = _settingsRepo.isDarkThemeSelected()
          ? Brightness.dark
          : Brightness.light;
      emit(ThemeState(brightness));
    } catch (e) {
      log(e.toString());
    }
  }
}
