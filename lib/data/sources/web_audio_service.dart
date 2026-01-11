import 'dart:async';
import 'dart:js_interop';

import 'package:audioplayers/audioplayers.dart';
import 'package:web/web.dart' as web;
import 'package:yx_scope/yx_scope.dart';

import 'audio_service.dart';

class WebAudioService implements AudioService, AsyncLifecycle {
  bool _initialized = false;
  bool _pendingMusicPlayback = false;
  bool _userInteracted = false;

  final _musicPlayer = AudioPlayer();

  double _volume = 1.0;
  double _soundVolume = 1.0;
  double _musicVolume = 1.0;

  static const String _ambientAssetPath =
      '840198__younoise__before-the-northern-lights-ambient.wav';
  static const String _enemyDeathAssetPath = 'enemy_death.wav';
  static const String _playerDamageAssetPath = 'player_damage.wav';

  @override
  Future<void> init() async {
    if (_initialized) return;

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);

    _setupUserInteractionListener();

    _initialized = true;
  }

  void _setupUserInteractionListener() {
    void onInteraction(web.Event event) {
      if (_userInteracted) return;
      _userInteracted = true;

      if (_pendingMusicPlayback) {
        _pendingMusicPlayback = false;
        unawaited(_startMusic());
      }
    }

    final callback = onInteraction.toJS;
    web.document.addEventListener('click', callback);
    web.document.addEventListener('keydown', callback);
    web.document.addEventListener('touchstart', callback);
  }

  Future<void> _startMusic() async {
    await _musicPlayer.setVolume(_volume * _musicVolume);
    await _musicPlayer.play(AssetSource(_ambientAssetPath));
  }

  @override
  void playSound(SoundEffect effect) {
    if (!_initialized || !_userInteracted) return;

    final String assetPath;

    switch (effect) {
      case SoundEffect.enemyDeath:
        assetPath = _enemyDeathAssetPath;
        break;
      case SoundEffect.playerHit:
        assetPath = _playerDamageAssetPath;
        break;
      case SoundEffect.shoot:
      case SoundEffect.typeError:
      case SoundEffect.typeSuccess:
      case SoundEffect.gameOver:
      case SoundEffect.victory:
      case SoundEffect.menuSelect:
        return;
    }

    unawaited(_playEffect(assetPath));
  }

  Future<void> _playEffect(String assetPath) async {
    final player = AudioPlayer();
    await player.setVolume(_volume * _soundVolume);
    await player.play(AssetSource(assetPath));
    player.onPlayerComplete.first.then((_) => player.dispose());
  }

  @override
  void playBackgroundMusic() {
    if (!_initialized) return;

    if (!_userInteracted) {
      _pendingMusicPlayback = true;
      return;
    }

    unawaited(_startMusic());
  }

  @override
  void stopBackgroundMusic() {
    _musicPlayer.pause();
  }

  @override
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _updateMusicVolume();
  }

  @override
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  @override
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _updateMusicVolume();
  }

  void _updateMusicVolume() {
    _musicPlayer.setVolume(_volume * _musicVolume);
  }

  @override
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    _initialized = false;
  }
}
