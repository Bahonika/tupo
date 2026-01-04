import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:yx_scope/yx_scope.dart';

import 'audio_service.dart';

/// Реализация AudioService с использованием SoLoud для воспроизведения ambient и звуковых эффектов
class SoloudAudioService implements AudioService, AsyncLifecycle {
  SoLoud? _soloud;
  bool _initialized = false;
  
  // Ambient фоновая музыка
  AudioSource? _ambientMusic;
  SoundHandle? _ambientHandle;
  
  // Звуковые эффекты
  AudioSource? _enemyDeathSound;
  AudioSource? _playerDamageSound;
  
  // Громкости
  double _volume = 1.0;
  double _soundVolume = 1.0;
  double _musicVolume = 1.0;

  static const String _ambientAssetPath = 'assets/840198__younoise__before-the-northern-lights-ambient.wav';
  static const String _enemyDeathAssetPath = 'assets/enemy_death.wav';
  static const String _playerDamageAssetPath = 'assets/player_damage.wav';

  @override
  Future<void> init() async {
    if (_initialized) return;

    _soloud = SoLoud.instance;
    await _soloud!.init();
    
    // Загружаем ambient файл
    try {
      _ambientMusic = await _soloud!.loadAsset(_ambientAssetPath);
    } catch (e) {
      // Игнорируем ошибки загрузки
    }
    
    // Загружаем звуковые эффекты
    try {
      _enemyDeathSound = await _soloud!.loadAsset(_enemyDeathAssetPath);
    } catch (e) {
      // Игнорируем ошибки загрузки
    }
    
    try {
      _playerDamageSound = await _soloud!.loadAsset(_playerDamageAssetPath);
    } catch (e) {
      // Игнорируем ошибки загрузки
    }
    
    _initialized = true;
  }

  @override
  void playSound(SoundEffect effect) {
    if (!_initialized || _soloud == null) return;
    
    AudioSource? sound;
    
    switch (effect) {
      case SoundEffect.enemyDeath:
        sound = _enemyDeathSound;
        break;
      case SoundEffect.playerHit:
        sound = _playerDamageSound;
        break;
      case SoundEffect.shoot:
      case SoundEffect.typeError:
      case SoundEffect.typeSuccess:
      case SoundEffect.gameOver:
      case SoundEffect.victory:
      case SoundEffect.menuSelect:
        // Остальные звуки пока не реализованы
        return;
    }
    
    if (sound != null) {
      _playSoundEffect(sound);
    }
  }
  
  void _playSoundEffect(AudioSource sound) {
    if (_soloud == null) return;
    
    try {
      _soloud!.play(
        sound,
        volume: _volume * _soundVolume,
      );
    } catch (e) {
      // Игнорируем ошибки воспроизведения
    }
  }

  @override
  void playBackgroundMusic() {
    if (!_initialized || _soloud == null || _ambientMusic == null) return;
    
    // Если уже играет, не запускаем повторно
    if (_ambientHandle != null) return;
    
    _soloud!.play(
      _ambientMusic!,
      volume: _volume * _musicVolume,
    ).then((handle) async {
      _soloud!.setLooping(handle, true);
      _ambientHandle = handle;
    }).catchError((e) {
      // Игнорируем ошибки воспроизведения
    });
  }

  @override
  void stopBackgroundMusic() {
    if (_soloud == null || _ambientHandle == null) return;
    
    try {
      _soloud!.stop(_ambientHandle!);
      _ambientHandle = null;
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _updateAmbientVolume();
  }

  @override
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  @override
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _updateAmbientVolume();
  }

  void _updateAmbientVolume() {
    if (_soloud == null || _ambientHandle == null) return;
    
    try {
      _soloud!.setVolume(_ambientHandle!, _volume * _musicVolume);
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  @override
  Future<void> dispose() async {
    stopBackgroundMusic();
    
    if (_soloud != null) {
      if (_ambientMusic != null) {
        _soloud!.disposeSource(_ambientMusic!);
      }
      if (_enemyDeathSound != null) {
        _soloud!.disposeSource(_enemyDeathSound!);
      }
      if (_playerDamageSound != null) {
        _soloud!.disposeSource(_playerDamageSound!);
      }
      _soloud!.deinit();
    }
    _initialized = false;
  }
}
