import 'package:shared_preferences/shared_preferences.dart';
import 'package:yx_scope/yx_scope.dart';

import '../../shared/models/settings.dart';

/// Абстрактный интерфейс для хранения настроек
abstract class SettingsStorage {
  Future<Settings> loadSettings();
  Future<void> saveSettings(Settings settings);
}

/// Реализация хранения настроек через SharedPreferences
class SharedPreferencesSettingsStorage implements SettingsStorage, AsyncLifecycle {
  static const String _keyFullscreen = 'settings_fullscreen';
  static const String _keyDifficulty = 'settings_difficulty';
  static const String _keyLanguage = 'settings_language';
  static const String _keySoundVolume = 'settings_sound_volume';
  static const String _keyMusicVolume = 'settings_music_volume';

  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> dispose() async {
    // SharedPreferences не требует dispose
  }

  @override
  Future<Settings> loadSettings() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    
    return Settings(
      fullscreen: prefs.getBool(_keyFullscreen) ?? false,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == prefs.getString(_keyDifficulty),
        orElse: () => Difficulty.medium,
      ),
      language: Language.values.firstWhere(
        (l) => l.name == prefs.getString(_keyLanguage),
        orElse: () => Language.russian,
      ),
      soundVolume: prefs.getDouble(_keySoundVolume) ?? 1.0,
      musicVolume: prefs.getDouble(_keyMusicVolume) ?? 1.0,
    );
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    
    await Future.wait([
      prefs.setBool(_keyFullscreen, settings.fullscreen),
      prefs.setString(_keyDifficulty, settings.difficulty.name),
      prefs.setString(_keyLanguage, settings.language.name),
      prefs.setDouble(_keySoundVolume, settings.soundVolume),
      prefs.setDouble(_keyMusicVolume, settings.musicVolume),
    ]);
  }
}
