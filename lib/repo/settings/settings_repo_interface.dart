abstract interface class SettingsRepoInterface {
  bool isDarkThemeSelected();
  Future<void> setDarkThemeSelected(bool selected);
}