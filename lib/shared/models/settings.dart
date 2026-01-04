/// Уровни сложности игры
enum Difficulty {
  easy,
  medium,
  hard,
  extreme,
}

/// Языки интерфейса
enum Language {
  russian,
  english,
}

/// Модель настроек игры
class Settings {
  /// Полноэкранный режим (только для Windows)
  final bool fullscreen;

  /// Уровень сложности
  final Difficulty difficulty;

  /// Язык интерфейса
  final Language language;

  /// Громкость звуков (0.0 - 1.0)
  final double soundVolume;

  /// Громкость музыки (0.0 - 1.0)
  final double musicVolume;

  const Settings({
    this.fullscreen = false,
    this.difficulty = Difficulty.medium,
    this.language = Language.russian,
    this.soundVolume = 1.0,
    this.musicVolume = 1.0,
  });

  Settings copyWith({
    bool? fullscreen,
    Difficulty? difficulty,
    Language? language,
    double? soundVolume,
    double? musicVolume,
  }) {
    return Settings(
      fullscreen: fullscreen ?? this.fullscreen,
      difficulty: difficulty ?? this.difficulty,
      language: language ?? this.language,
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Settings &&
        other.fullscreen == fullscreen &&
        other.difficulty == difficulty &&
        other.language == language &&
        other.soundVolume == soundVolume &&
        other.musicVolume == musicVolume;
  }

  @override
  int get hashCode => Object.hash(
        fullscreen,
        difficulty,
        language,
        soundVolume,
        musicVolume,
      );
}
