import 'dart:async';

import 'package:typo/domain/state/target_state.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/enemies_state.dart';
import '../state/game_state.dart';
import '../state_managers/target_state_manager.dart';
import '../state_managers/typing_state_manager.dart';

/// Interactor для управления целью (выделенным врагом)
class TargetInteractor implements AsyncLifecycle {
  final TargetStateManager _targetState;
  final TypingStateManager _typingState;
  final StateReadable<GameState> _gameState;
  final StateReadable<EnemiesState> _enemiesState;

  StreamSubscription<GameStatus>? _gameStateSubscription;
  StreamSubscription<EnemiesState>? _enemiesStateSubscription;

  TargetInteractor({
    required TargetStateManager targetState,
    required TypingStateManager typingState,
    required StateReadable<GameState> gameState,
    required StateReadable<EnemiesState> enemiesState,
  })  : _targetState = targetState,
        _typingState = typingState,
        _gameState = gameState,
        _enemiesState = enemiesState;

  @override
  Future<void> init() async {
    _gameStateSubscription ??= _gameState.stream
        .map((state) => state.status)
        .distinct()
        .listen((status) {
      final isEndState = status == GameStatus.menu ||
          status == GameStatus.gameOver ||
          status == GameStatus.win;

      if (isEndState) {
        _clearTargetIfNeeded();
      }
    });

    _enemiesStateSubscription ??= _enemiesState.stream.distinct().listen((state) {
      final currentTargetId = _targetState.state.mapOrNull(
        selected: (selected) => selected.enemyId,
      );

      if (currentTargetId == null) return;

      if (state.lastCollidedEnemyId == currentTargetId) {
        _clearTargetIfNeeded();
      }

      final enemy = state.activeEnemies[currentTargetId];
      if (enemy != null && enemy.isDestroyed) {
        _clearTargetIfNeeded();
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;
    await _enemiesStateSubscription?.cancel();
    _enemiesStateSubscription = null;
  }

  void _clearTargetIfNeeded() {
    if (_targetState.state.hasTarget) {
      _targetState.clearTarget();
      _typingState.reset();
    }
  }

  /// Выделить врага (прицелиться)
  Future<void> selectTarget(String enemyId, String word) async {
    final currentEnemyId = _targetState.state.mapOrNull(
      selected: (selected) => selected.enemyId,
    );
    if (currentEnemyId == enemyId) return;
    await _targetState.setTarget(enemyId, word);
    await _typingState.reset();
  }

  /// Снять выделение с врага
  Future<void> clearTarget() async {
    if (_targetState.state.mapOrNull(selected: (_) => true) == false) return;
    await _targetState.clearTarget();
    await _typingState.reset();
  }
}
