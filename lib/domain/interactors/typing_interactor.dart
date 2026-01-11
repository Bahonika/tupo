import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/game_state.dart';
import '../state_managers/typing_state_manager.dart';

/// Interactor для управления набором текста
class TypingInteractor implements AsyncLifecycle {
  final TypingStateManager _typingState;
  final StateReadable<GameState> _gameState;

  StreamSubscription<GameStatus>? _gameStateSubscription;

  TypingInteractor({
    required TypingStateManager typingState,
    required StateReadable<GameState> gameState,
  })  : _typingState = typingState,
        _gameState = gameState;

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
        _typingState.reset();
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;
  }

  /// Сбросить флаг ошибки ввода
  Future<void> clearError() async {
    await _typingState.clearError();
  }
}
