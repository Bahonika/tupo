import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/game_state.dart';
import '../state_managers/player_state_manager.dart';

/// Interactor для управления персонажем
class PlayerInteractor implements AsyncLifecycle {
  final PlayerStateManager _playerState;
  final StateReadable<GameState> _gameState;

  StreamSubscription<List<GameStatus>>? _gameStateSubscription;

  PlayerInteractor({
    required PlayerStateManager playerState,
    required StateReadable<GameState> gameState,
  })  : _playerState = playerState,
        _gameState = gameState;

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

      if (previous == GameStatus.menu && current == GameStatus.playing) {
        _playerState.initializeHealth();
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;
  }

  /// Установить угол направления игрока
  Future<void> setAngle(double angle) async {
    await _playerState.setAngle(angle);
  }
}
