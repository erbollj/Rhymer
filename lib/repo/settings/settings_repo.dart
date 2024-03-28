import 'package:rhymer/repo/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepo implements SettingsRepoInterface {
  SettingsRepo({required this.prefs});

  final SharedPreferences prefs;

  static const _isDarkThemeSelectedKey = "dark_theme_selected";

  @override
  bool isDarkThemeSelected() {
    final selected = prefs.getBool(_isDarkThemeSelectedKey);
    return selected ?? false;
  }

  @override
  Future<void> setDarkThemeSelected(bool selected) async {
    prefs.setBool(_isDarkThemeSelectedKey, selected);
  }

}
