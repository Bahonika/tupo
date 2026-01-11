import 'dart:async';

import 'package:typo/domain/state/target_state.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../data/repositories/word_repository.dart';
import '../../data/sources/audio_service.dart';
import '../../shared/models/settings.dart';
import '../state/game_state.dart';
import '../state/player_state.dart';
import '../state/settings_state.dart';
import '../state_managers/enemies_state_manager.dart';
import '../state_managers/game_state_manager.dart';
import '../state_managers/typing_state_manager.dart';

/// Interactor для координации игровой логики
class GameInteractor implements AsyncLifecycle {
  final GameStateManager _gameState;
  final TypingStateManager _typingState;
  final EnemiesStateManager _enemiesState;
  final WordRepository _wordRepository;
  final AudioService _audioService;
  final StateReadable<SettingsState> _settingsState;
  final StateReadable<TargetState> _targetState;
  final StateReadable<PlayerState> _playerState;

  StreamSubscription<GameStatus>? _gameOverSubscription;
  StreamSubscription<int>? _playerHealthSubscription;
  StreamSubscription<Language>? _languageSubscription;

  GameInteractor({
    required GameStateManager gameState,
    required TypingStateManager typingState,
    required EnemiesStateManager enemiesState,
    required WordRepository wordRepository,
    required AudioService audioService,
    required StateReadable<SettingsState> settingsState,
    required StateReadable<TargetState> targetState,
    required StateReadable<PlayerState> playerState,
  })  : _gameState = gameState,
        _typingState = typingState,
        _enemiesState = enemiesState,
        _wordRepository = wordRepository,
        _audioService = audioService,
        _settingsState = settingsState,
        _targetState = targetState,
        _playerState = playerState;

  @override
  Future<void> init() async {
    final currentLanguage = _settingsState.state.settings.language;
    _wordRepository.updateLanguage(currentLanguage);

    _gameOverSubscription ??= _gameState.stream
        .map((state) => state.status)
        .distinct()
        .listen((status) {
      if (status == GameStatus.gameOver) {
        _audioService.playSound(SoundEffect.gameOver);
      } else if (status == GameStatus.win) {
        _audioService.playSound(SoundEffect.victory);
      }
    });

    _playerHealthSubscription ??= _playerState.stream
        .map((state) => state.health)
        .distinct()
        .listen((health) {
      if (health <= 0 && _gameState.state.isPlaying) {
        _gameState.setGameOver();
      }
    });

    _languageSubscription ??= _settingsState.stream
        .map((state) => state.settings.language)
        .distinct()
        .listen((language) {
      _wordRepository.updateLanguage(language);
    });
  }

  @override
  Future<void> dispose() async {
    await _gameOverSubscription?.cancel();
    _gameOverSubscription = null;
    await _playerHealthSubscription?.cancel();
    _playerHealthSubscription = null;
    await _languageSubscription?.cancel();
    _languageSubscription = null;
  }

  /// Начать игру
  Future<void> startGame() async {
    _wordRepository.resetUsedWords();
    _wordRepository.resetUsedPhrases();
    await _gameState.startGame();
  }

  /// Поставить на паузу
  Future<void> pauseGame() async {
    await _gameState.pause();
  }

  /// Продолжить игру
  Future<void> resumeGame() async {
    await _gameState.resume();
  }

  /// Вернуться в меню
  Future<void> returnToMenu() async {
    await _gameState.returnToMenu();
  }

  /// Обработать ввод символа
  Future<void> onCharacterTyped(String char) async {
    if (!_gameState.state.isPlaying) {
      return;
    }

    final target = _targetState.state;
    final targetData = target.mapOrNull(
      selected: (selected) => (enemyId: selected.enemyId, word: selected.word),
    );
    if (targetData == null) {
      return;
    }

    final result = await _typingState.processChar(char, targetData.word);

    switch (result) {
      case TypingResult.correct:
        _audioService.playSound(SoundEffect.typeSuccess);
        break;

      case TypingResult.error:
        _audioService.playSound(SoundEffect.typeError);
        break;

      case TypingResult.complete:
        _audioService.playSound(SoundEffect.enemyDeath);
        await _onEnemyKilled(targetData.enemyId);
        break;

      case TypingResult.noTarget:
        break;
    }
  }

  /// Обработка уничтожения врага
  Future<void> _onEnemyKilled(String enemyId) async {
    final wordLength = _targetState.state.map(
      selected: (selected) => selected.word.length,
      none: (_) => 0,
    );
    final baseScore = 10;
    final lengthBonus = wordLength * 2;
    await _gameState.addScore(baseScore + lengthBonus);

    await _gameState.incrementKillCount();

    await _enemiesState.markEnemyDestroyed(enemyId);
  }
}
