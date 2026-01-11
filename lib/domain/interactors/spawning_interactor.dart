import 'dart:async';
import 'dart:math';

import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../shared/models/game_config.dart';
import '../../shared/utils/math_utils.dart';
import '../state/game_state.dart';
import '../state/settings_state.dart';
import '../state_managers/enemies_state_manager.dart';

/// Interactor для управления спавном врагов
class SpawningInteractor implements AsyncLifecycle {
  final StateReadable<GameState> _gameState;
  final EnemiesStateManager _enemiesState;
  final StateReadable<SettingsState> _settingsState;
  final GameConfig _config;

  final Random _random = Random();

  StreamSubscription<GameState>? _gameStateSubscription;
  double _elapsedTime = 0.0;

  SpawningInteractor({
    required StateReadable<GameState> gameState,
    required EnemiesStateManager enemiesState,
    required StateReadable<SettingsState> settingsState,
    required GameConfig config,
  })  : _gameState = gameState,
        _enemiesState = enemiesState,
        _settingsState = settingsState,
        _config = config;

  @override
  Future<void> init() async {
    _gameStateSubscription ??= _gameState.stream.distinct().listen((state) {
      if (!_enemiesState.state.isSpawning) return;

      if (state.isMenu || state.isGameOver || state.isWin) {
        _enemiesState.stopSpawning();
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;
    _enemiesState.stopSpawning();
  }

  /// Запустить спавн врагов
  Future<void> startSpawning() async {
    if (_enemiesState.state.isSpawning) return;

    await _enemiesState.startSpawning();
    _elapsedTime = _config.spawnInterval.inSeconds.toDouble();
  }

  /// Остановить спавн врагов
  Future<void> stopSpawning() async {
    await _enemiesState.stopSpawning();
    _elapsedTime = 0.0;
  }

  /// Обновить таймер спавна
  void updateSpawnTimer(
    double dt,
    double gameWidth,
    double gameHeight,
  ) {
    if (!_enemiesState.state.isSpawning || !_gameState.state.isPlaying) return;
    if (gameWidth <= 0 || gameHeight <= 0) return;

    _elapsedTime += dt;
    final spawnIntervalSeconds = _config.spawnInterval.inSeconds.toDouble();

    if (_elapsedTime >= spawnIntervalSeconds) {
      _elapsedTime = 0.0;
      _trySpawnEnemy(gameWidth, gameHeight);
    }
  }

  void _trySpawnEnemy(double gameWidth, double gameHeight) {
    if (!_gameState.state.isPlaying) return;

    final activeCount = _enemiesState.state.activeEnemies.values
        .where((e) => !e.isDestroyed && !e.hasReachedTarget)
        .length;

    if (activeCount >= _config.maxEnemies) return;

    final centerX = gameWidth / 2;
    final centerY = gameHeight / 2;
    final spawnRadius = max(gameWidth, gameHeight) * 0.7;

    final (spawnX, spawnY) = MathUtils.randomPointOnCircle(
      centerX,
      centerY,
      spawnRadius,
      _random,
    );

    _enemiesState.createAndSpawnEnemy(
      spawnX: spawnX,
      spawnY: spawnY,
      centerX: centerX,
      centerY: centerY,
      difficulty: _settingsState.state.settings.difficulty,
    );
  }
}
