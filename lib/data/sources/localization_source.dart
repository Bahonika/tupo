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

/// Source для доступа к данным локализации
class LocalizationSource {
  static const Map<LocalizationKey, String> _russianTranslations = {
    LocalizationKey.gameTitle: 'TUPO',
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

  static const Map<LocalizationKey, String> _englishTranslations = {
    LocalizationKey.gameTitle: 'TUPO',
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

  /// Получить перевод для ключа на указанном языке
  String translate(LocalizationKey key, Language language) {
    switch (language) {
      case Language.russian:
        return _russianTranslations[key] ?? key.toString();
      case Language.english:
        return _englishTranslations[key] ?? key.toString();
    }
  }
}
