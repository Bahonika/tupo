
import '../data/sources/audio_service.dart';
import '../data/sources/localization_service.dart';
import '../domain/state_managers/settings_state_manager.dart';
import '../presentation/game/tupo_game.dart';

/// Интерфейс scope для игры Tupo
abstract interface class TupoScope {
  TypoGame get game;
  SettingsStateManager get settingsState;
  AudioService get audioService;
  LocalizationService get localizationService;
}
