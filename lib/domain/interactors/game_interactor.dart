import 'dart:async';
import 'dart:math';

import 'package:yx_scope/yx_scope.dart';

import '../../data/repositories/word_repository.dart';
import '../../data/sources/audio_service.dart';
import '../../shared/models/game_config.dart';
import '../../shared/models/settings.dart';
import '../models/enemy_data.dart';
import '../state/game_state.dart';
import '../state/settings_state.dart';
import '../state_managers/game_state_manager.dart';
import '../state_managers/settings_state_manager.dart';
import '../state_managers/typing_state_manager.dart';

/// Interactor для координации игровой логики
class GameInteractor implements AsyncLifecycle {
  final GameStateManager _gameState;
  final TypingStateManager _typingState;
  final WordRepository _wordRepository;
  final AudioService _audioService;
  final GameConfig _config;
  final SettingsStateManager _settingsState;

  final Random _random = Random();

  StreamSubscription<GameState>? _gameOverSubscription;
  StreamSubscription<SettingsState>? _languageSubscription;

  /// Callback для уведомления о необходимости спавна врага
  void Function(EnemyData enemy)? onEnemySpawn;

  /// Callback для уведомления об уничтожении врага
  void Function(String enemyId)? onEnemyKilled;

  GameInteractor({
    required GameStateManager gameState,
    required TypingStateManager typingState,
    required WordRepository wordRepository,
    required AudioService audioService,
    required GameConfig config,
    required SettingsStateManager settingsState,
  })  : _gameState = gameState,
        _typingState = typingState,
        _wordRepository = wordRepository,
        _audioService = audioService,
        _config = config,
        _settingsState = settingsState;

  @override
  Future<void> init() async {
    // Устанавливаем текущий язык из настроек
    final currentLanguage = _settingsState.state.settings.language;
    _wordRepository.updateLanguage(currentLanguage);

    // Подписка на game over/win для воспроизведения звуков
    _gameOverSubscription = _gameState.stream.listen((state) {
      if (state.isGameOver) {
        _audioService.playSound(SoundEffect.gameOver);
      } else if (state.isWin) {
        _audioService.playSound(SoundEffect.victory);
      }
    });

    // Подписка на изменения языка
    _languageSubscription = _settingsState.stream.listen((state) {
      final newLanguage = state.settings.language;
      _wordRepository.updateLanguage(newLanguage);
    });
  }

  @override
  Future<void> dispose() async {
    await _gameOverSubscription?.cancel();
    await _languageSubscription?.cancel();
  }

  /// Начать игру
  Future<void> startGame() async {
    _wordRepository.resetUsedWords();
    _wordRepository.resetUsedPhrases();
    await _gameState.startGame();
    await _typingState.reset();
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
    await _typingState.reset();
  }

  /// Выделить врага (прицелиться)
  Future<void> selectTarget(String enemyId, String word) async {
    await _gameState.setTarget(enemyId);
    await _typingState.setTargetWord(word);
  }

  /// Снять выделение с врага
  Future<void> clearTarget() async {
    await _gameState.setTarget(null);
    await _typingState.reset();
  }

  /// Обработать ввод символа
  Future<void> onCharacterTyped(String char) async {
    final currentTargetId = _gameState.state.targetEnemyId;
    if (!_gameState.state.isPlaying || currentTargetId == null) {
      return;
    }

    final result = await _typingState.processChar(char);

    switch (result) {
      case TypingResult.correct:
        _audioService.playSound(SoundEffect.typeSuccess);
        break;

      case TypingResult.error:
        _audioService.playSound(SoundEffect.typeError);
        break;

      case TypingResult.complete:
        _audioService.playSound(SoundEffect.enemyDeath);
        await _onEnemyKilled(currentTargetId);
        break;

      case TypingResult.noTarget:
        break;
    }
  }

  /// Обработка уничтожения врага
  Future<void> _onEnemyKilled(String enemyId) async {
    // Начисляем очки (базовые + бонус за длину слова)
    final wordLength = _typingState.state.targetWord.length;
    final baseScore = 10;
    final lengthBonus = wordLength * 2;
    await _gameState.addScore(baseScore + lengthBonus);

    // Увеличиваем счётчик убитых
    await _gameState.incrementKillCount();

    // Уведомляем о уничтожении
    onEnemyKilled?.call(enemyId);

    // Сбрасываем цель
    await clearTarget();
  }

  /// Обработка столкновения врага с игроком
  Future<void> onEnemyCollision(String enemyId, int damage) async {
    _audioService.playSound(SoundEffect.playerHit);
    await _gameState.takeDamage(damage);

    // Если это была текущая цель — сбрасываем
    if (_gameState.state.targetEnemyId == enemyId) {
      await clearTarget();
    }
  }

  /// Создать данные для нового врага
  EnemyData createEnemyData() {
    final difficulty = _settingsState.state.settings.difficulty;
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    String word;
    EnemyType type = EnemyType.normal;
    bool isBoss = false;

    // Логика сложности
    switch (difficulty) {
      case Difficulty.easy:
        // Легкая: только слова <= 7 символов
        word = _wordRepository.getUniqueWord(useEasyWords: true);
        break;

      case Difficulty.medium:
        // Средняя: слова любой длины
        word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
        break;

      case Difficulty.hard:
        // Сложная: слова любой длины + 5% шанс босса
        if (_random.nextInt(20) == 0) {
          // Босс со словосочетанием
          word = _wordRepository.getUniquePhrase();
          type = EnemyType.special;
          isBoss = true;
        } else {
          word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
        }
        break;

      case Difficulty.extreme:
        // Экстрим: 10% wavy враги, 5% боссы, 85% обычные
        final roll = _random.nextInt(100);
        if (roll < 5) {
          // 5% шанс босса
          word = _wordRepository.getUniquePhrase();
          type = EnemyType.special;
          isBoss = true;
        } else if (roll < 15) {
          // 10% шанс wavy врага
          word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
          type = EnemyType.wavy;
        } else {
          // 85% обычные враги
          word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
        }
        break;
    }

    // Скорость зависит от длины слова (короткие слова = быстрые враги)
    // Для боссов скорость немного ниже
    final baseSpeedMultiplier = 1.0 + (10 - word.length) * 0.1;
    final bossSpeedMultiplier = isBoss ? 0.8 : 1.0;
    final speedMultiplier = baseSpeedMultiplier * bossSpeedMultiplier;
    final speed = _config.enemySpeedBase * speedMultiplier;

    // Урон зависит от длины слова, боссы наносят больше урона
    final baseDamage = 5 + word.length * 2;
    final damage = isBoss ? (baseDamage * 1.5).round() : baseDamage;

    return EnemyData(
      id: id,
      word: word,
      speed: speed,
      damage: damage,
      type: type,
    );
  }
}
