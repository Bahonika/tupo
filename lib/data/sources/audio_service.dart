import 'package:yx_scope/yx_scope.dart';

/// Типы звуковых эффектов
enum SoundEffect {
  shoot,
  enemyDeath,
  playerHit,
  typeError,
  typeSuccess,
  gameOver,
  victory,
  menuSelect,
}

/// Абстрактный сервис для воспроизведения звуков
abstract class AudioService implements AsyncLifecycle {
  /// Инициализация аудио движка
  @override
  Future<void> init() async {
    // Implement initialization logic here
  }

  /// Воспроизведение звукового эффекта
  void playSound(SoundEffect effect);

  /// Воспроизведение фоновой музыки
  void playBackgroundMusic();

  /// Остановка фоновой музыки
  void stopBackgroundMusic();

  /// Установка громкости (0.0 - 1.0)
  void setVolume(double volume);

  /// Установка громкости звуков (0.0 - 1.0)
  void setSoundVolume(double volume);

  /// Установка громкости музыки (0.0 - 1.0)
  void setMusicVolume(double volume);

  /// Освобождение ресурсов
  @override
  Future<void> dispose() async {
    // Implement disposal logic here
  }
}

/// Заглушка аудио сервиса (без реального воспроизведения)
class StubAudioService implements AudioService, AsyncLifecycle {
  bool _isInitialized = false;
  double _volume = 1.0;
  double _soundVolume = 1.0;
  double _musicVolume = 1.0;

  @override
  Future<void> init() async {
    _isInitialized = true;
  }

  @override
  void playSound(SoundEffect effect) {
    if (!_isInitialized) return;
    // Заглушка: просто логируем
    // print('Playing sound: ${effect.name}');
  }

  @override
  void playBackgroundMusic() {
    if (!_isInitialized) return;
    // Заглушка
  }

  @override
  void stopBackgroundMusic() {
    // Заглушка
  }

  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }

  @override
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  @override
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}
