import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx_state/yx_state.dart';

import '../../domain/interactors/game_interactor.dart';
import '../../domain/interactors/game_loop_interactor.dart';
import '../../domain/interactors/input_interactor.dart';
import '../../domain/interactors/spawning_interactor.dart';
import '../../domain/interactors/typing_interactor.dart';
import '../../domain/state/enemies_state.dart';
import '../../domain/state/game_state.dart';
import '../../domain/state/player_state.dart';
import '../../domain/state/target_state.dart';
import '../../domain/state/typing_state.dart';
import 'components/enemy_component.dart';
import 'components/player_component.dart';
import 'components/state_listener_component.dart';

class TypoGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, MouseMovementDetector {
  final StateReadable<GameState> gameState;
  final StateReadable<TypingState> typingState;
  final StateReadable<EnemiesState> enemiesState;
  final StateReadable<TargetState> targetState;
  final StateReadable<PlayerState> playerState;
  final GameInteractor interactor;
  final SpawningInteractor spawningInteractor;
  final GameLoopInteractor gameLoopInteractor;
  final InputInteractor inputInteractor;
  final TypingInteractor typingInteractor;

  TypoGame({
    required this.gameState,
    required this.typingState,
    required this.enemiesState,
    required this.targetState,
    required this.playerState,
    required this.interactor,
    required this.spawningInteractor,
    required this.gameLoopInteractor,
    required this.inputInteractor,
    required this.typingInteractor,
  });

  PlayerComponent? _player;

  Vector2 get center => size / 2;

  @override
  Color backgroundColor() => const Color(0xFFF5F5F5);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(StateListenerComponent<GameState>(
      stateReadable: gameState,
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (previous, current) => _onGameStatusChanged(current.status),
    ));

    // Подписка на добавление новых врагов
    world.add(StateListenerComponent<EnemiesState>(
      stateReadable: enemiesState,
      listenWhen: (prev, curr) =>
          prev.activeEnemies.length != curr.activeEnemies.length,
      listener: (previous, current) => _onEnemiesChanged(previous, current),
    ));

    overlays.add('MainMenu');
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (_player == null && size.x > 0 && size.y > 0) {
      _player = PlayerComponent(
        playerState: playerState,
        position: center,
      );
      world.add(_player!);
    } else if (_player != null) {
      _player!.position = center;
    }
  }

  void _onGameStatusChanged(GameStatus status) {
    switch (status) {
      case GameStatus.gameOver:
      case GameStatus.win:
        spawningInteractor.stopSpawning();
        pauseEngine();
        overlays.add('GameOver');
      case GameStatus.paused:
        pauseEngine();
      case GameStatus.playing:
        resumeEngine();
      case GameStatus.menu:
        break;
    }
  }

  void _onEnemiesChanged(EnemiesState previous, EnemiesState current) {
    for (final entry in current.activeEnemies.entries) {
      if (!previous.activeEnemies.containsKey(entry.key)) {
        _spawnEnemyComponent(entry.key, entry.value);
      }
    }
  }

  void _spawnEnemyComponent(String id, dynamic activeEnemy) {
    final enemy = EnemyComponent(
      enemyId: id,
      data: activeEnemy.data,
      initialPosition: Vector2(activeEnemy.x, activeEnemy.y),
      enemiesState: enemiesState,
      typingState: typingState,
      targetState: targetState,
    );

    world.add(enemy);
  }

  void startGame() {
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('HUD');

    interactor.startGame();
    spawningInteractor.startSpawning();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.state.isPlaying) return;

    gameLoopInteractor.update(
      dt: dt,
      screenWidth: size.x,
      screenHeight: size.y,
    );
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      final wasPaused = gameState.state.isPaused;
      final result = inputInteractor.onEscapePressed();
      if (result == KeyInputResult.handled) {
        if (wasPaused) {
          overlays.remove('PauseMenu');
        } else {
          overlays.add('PauseMenu');
        }
      }
      return result == KeyInputResult.handled
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }

    if (!gameState.state.isPlaying) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      inputInteractor.onCharacterInput(' ');
      return KeyEventResult.handled;
    }

    final char = event.character;
    if (char != null && char.isNotEmpty) {
      if (RegExp(r'^[a-zA-Zа-яА-ЯёЁ]$').hasMatch(char)) {
        inputInteractor.onCharacterInput(char);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    inputInteractor.onMouseMove(
      info.eventPosition.global.x,
      info.eventPosition.global.y,
    );
  }

  void returnToMenu() {
    overlays.remove('GameOver');
    overlays.remove('HUD');
    overlays.remove('PauseMenu');
    overlays.add('MainMenu');

    interactor.returnToMenu();
    resumeEngine();
  }
}
