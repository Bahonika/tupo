import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/game_state.dart';
import '../state_managers/enemies_state_manager.dart';

/// Interactor для реактивной очистки врагов при смене состояния игры
class EnemiesCleanupInteractor implements AsyncLifecycle {
  final StateReadable<GameState> _gameState;
  final EnemiesStateManager _enemiesState;

  StreamSubscription<List<GameStatus>>? _gameStateSubscription;

  EnemiesCleanupInteractor({
    required StateReadable<GameState> gameState,
    required EnemiesStateManager enemiesState,
  })  : _gameState = gameState,
        _enemiesState = enemiesState;

  @override
  Future<void> init() async {
    _gameStateSubscription ??= _gameState.stream
        .map((state) => state.status)
        .distinct()
        .startWith(_gameState.state.status)
        .pairwise()
        .listen((pair) {
      final previous = pair.first;
      final current = pair.last;

      final isTransitionToMenu = current == GameStatus.menu;
      final isStartingGame =
          previous == GameStatus.menu && current == GameStatus.playing;

      if (isTransitionToMenu || isStartingGame) {
        _enemiesState.clearAllEnemies();
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;
  }
}
