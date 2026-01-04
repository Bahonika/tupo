import 'dart:async';

import 'package:yx_scope/yx_scope.dart';

import '../../domain/state/settings_state.dart';
import '../../domain/state_managers/settings_state_manager.dart';
import '../../shared/models/settings.dart';

/// Ключи для локализации
enum LocalizationKey {
  gameTitle,
  gameSubtitle,
  startGame,
  settings,
  howToPlay,
  hoverEnemy,
  typeWord,
  dontLetReach,
  pause,
  resume,
  backToMenu,
  gameOver,
  victory,
  playAgain,
  score,
  enemiesKilled,
  settingsTitle,
  fullscreen,
  difficulty,
  language,
  soundVolume,
  musicVolume,
  close,
  easy,
  medium,
  hard,
  extreme,
  russian,
  english,
}

/// Сервис для локализации UI
class LocalizationService implements AsyncLifecycle {
  final SettingsStateManager _settingsState;

  StreamSubscription<SettingsState>? _languageSubscription;
  Language _currentLanguage = Language.russian;

  LocalizationService(this._settingsState);

  /// Текущий язык
  Language get currentLanguage => _currentLanguage;

  /// Русские переводы
  static const Map<LocalizationKey, String> _russianTranslations = {
    LocalizationKey.gameTitle: 'TYPO',
    LocalizationKey.gameSubtitle: 'TYPING SHOOTER',
    LocalizationKey.startGame: 'НАЧАТЬ ИГРУ',
    LocalizationKey.settings: 'НАСТРОЙКИ',
    LocalizationKey.howToPlay: 'КАК ИГРАТЬ',
    LocalizationKey.hoverEnemy: 'Наведите курсор на врага',
    LocalizationKey.typeWord: 'Наберите слово над врагом',
    LocalizationKey.dontLetReach: 'Не дайте врагам добраться до вас!',
    LocalizationKey.pause: 'ПАУЗА',
    LocalizationKey.resume: 'ПРОДОЛЖИТЬ',
    LocalizationKey.backToMenu: 'В МЕНЮ',
    LocalizationKey.gameOver: 'ИГРА ОКОНЧЕНА',
    LocalizationKey.victory: 'ПОБЕДА!',
    LocalizationKey.playAgain: 'ИГРАТЬ СНОВА',
    LocalizationKey.score: 'Очки',
    LocalizationKey.enemiesKilled: 'Враги уничтожены',
    LocalizationKey.settingsTitle: 'НАСТРОЙКИ',
    LocalizationKey.fullscreen: 'Полноэкранный режим',
    LocalizationKey.difficulty: 'Сложность',
    LocalizationKey.language: 'Язык',
    LocalizationKey.soundVolume: 'Громкость звуков',
    LocalizationKey.musicVolume: 'Громкость музыки',
    LocalizationKey.close: 'ЗАКРЫТЬ',
    LocalizationKey.easy: 'Легкая',
    LocalizationKey.medium: 'Средняя',
    LocalizationKey.hard: 'Сложная',
    LocalizationKey.extreme: 'Экстрим',
    LocalizationKey.russian: 'Русский',
    LocalizationKey.english: 'English',
  };

  /// Английские переводы
  static const Map<LocalizationKey, String> _englishTranslations = {
    LocalizationKey.gameTitle: 'TYPO',
    LocalizationKey.gameSubtitle: 'TYPING SHOOTER',
    LocalizationKey.startGame: 'START GAME',
    LocalizationKey.settings: 'SETTINGS',
    LocalizationKey.howToPlay: 'HOW TO PLAY',
    LocalizationKey.hoverEnemy: 'Hover over enemy',
    LocalizationKey.typeWord: 'Type the word above enemy',
    LocalizationKey.dontLetReach: 'Don\'t let enemies reach you!',
    LocalizationKey.pause: 'PAUSED',
    LocalizationKey.resume: 'RESUME',
    LocalizationKey.backToMenu: 'BACK TO MENU',
    LocalizationKey.gameOver: 'GAME OVER',
    LocalizationKey.victory: 'VICTORY!',
    LocalizationKey.playAgain: 'PLAY AGAIN',
    LocalizationKey.score: 'Score',
    LocalizationKey.enemiesKilled: 'Enemies Killed',
    LocalizationKey.settingsTitle: 'SETTINGS',
    LocalizationKey.fullscreen: 'Fullscreen',
    LocalizationKey.difficulty: 'Difficulty',
    LocalizationKey.language: 'Language',
    LocalizationKey.soundVolume: 'Sound Volume',
    LocalizationKey.musicVolume: 'Music Volume',
    LocalizationKey.close: 'CLOSE',
    LocalizationKey.easy: 'Easy',
    LocalizationKey.medium: 'Medium',
    LocalizationKey.hard: 'Hard',
    LocalizationKey.extreme: 'Extreme',
    LocalizationKey.russian: 'Russian',
    LocalizationKey.english: 'English',
  };

  @override
  Future<void> init() async {
    // Устанавливаем текущий язык из настроек
    _currentLanguage = _settingsState.state.settings.language;

    // Подписываемся на изменения языка
    _languageSubscription = _settingsState.stream.listen((state) {
      _currentLanguage = state.settings.language;
    });
  }

  @override
  Future<void> dispose() async {
    await _languageSubscription?.cancel();
  }

  /// Получить перевод для ключа
  String translate(LocalizationKey key) {
    switch (_currentLanguage) {
      case Language.russian:
        return _russianTranslations[key] ?? key.toString();
      case Language.english:
        return _englishTranslations[key] ?? key.toString();
    }
  }
}
