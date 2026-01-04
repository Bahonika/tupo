import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx_scope/yx_scope.dart';

import '../../domain/interactors/game_interactor.dart';
import '../../domain/models/enemy_data.dart';
import '../../domain/state/game_state.dart';
import '../../domain/state_managers/game_state_manager.dart';
import '../../domain/state_managers/typing_state_manager.dart';
import '../../shared/utils/math_utils.dart';
import 'components/enemy_component.dart';
import 'components/player_component.dart';
import 'components/state_listener_component.dart';

class TypoGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, MouseMovementDetector
    implements AsyncLifecycle {
  final GameStateManager gameState;
  final TypingStateManager typingState;
  final GameInteractor interactor;

  TypoGame({
    required this.gameState,
    required this.typingState,
    required this.interactor,
  });

  PlayerComponent? _player;
  final Map<String, EnemyComponent> _enemies = {};
  final Random _random = Random();

  Vector2? _mousePosition;
  Timer? _spawnTimer;

  /// Радиус спавна врагов (за пределами экрана)
  double get spawnRadius => max(size.x, size.y) * 0.7;

  /// Центр игрового поля
  Vector2 get center => size / 2;

  /// Допуск угла для выделения врага (в радианах, ~15 градусов)
  static const double aimTolerance = 0.26;

  @override
  Future<void> init() async {
    // Настраиваем callbacks interactor
    interactor.onEnemyKilled = _onEnemyKilled;
  }

  @override
  Future<void> dispose() async {
    _spawnTimer?.stop();
  }

  @override
  Color backgroundColor() => const Color(0xFFF5F5F5);

  @override
  Future<void> onLoad() async {
    // Настройка камеры
    camera.viewfinder.anchor = Anchor.topLeft;

    // Используем реактивный компонент для отслеживания изменений состояния
    world.add(StateListenerComponent<GameState>(
      stateReadable: gameState,
      listener: (previous, current) => _onStateChanged(current),
    ));

    // Показываем главное меню
    overlays.add('MainMenu');
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // Создаём или обновляем позицию игрока при изменении размера
    if (_player == null && size.x > 0 && size.y > 0) {
      _player = PlayerComponent(position: center);
      world.add(_player!);
    } else if (_player != null) {
      _player!.position = center;
    }
  }

  @override
  void onRemove() {
    _spawnTimer?.stop();
    super.onRemove();
  }

  void _onStateChanged(GameState state) {
    if (state.isGameOver) {
      _stopGame();
      overlays.add('GameOver');
    } else if (state.isWin) {
      _stopGame();
      overlays.add('GameOver');
    } else if (state.isPaused) {
      pauseEngine();
    } else if (state.isPlaying) {
      resumeEngine();
    }
  }

  /// Запуск игры
  void startGame() {
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('HUD');

    // Очищаем предыдущих врагов (копируем список чтобы избежать concurrent modification)
    final enemiesToRemove = _enemies.values.toList();
    for (final enemy in enemiesToRemove) {
      enemy.removeFromParent();
    }
    _enemies.clear();

    // Запускаем через interactor
    interactor.startGame();

    // Запускаем спавн врагов
    _startSpawning();
  }

  void _startSpawning() {
    _spawnTimer?.stop();
    _spawnTimer = Timer(
      2.0, // Интервал спавна
      onTick: _spawnEnemy,
      repeat: true,
    );
    // Timer автоматически запускается, не нужен start()

    // Спавним первого врага сразу
    _spawnEnemy();
  }

  void _stopGame() {
    _spawnTimer?.stop();
    pauseEngine();
  }

  void _spawnEnemy() {
    if (!gameState.state.isPlaying) return;
    if (_enemies.length >= 10) return; // Максимум врагов на экране
    if (size.x <= 0 || size.y <= 0) return; // Размер не инициализирован

    final enemyData = interactor.createEnemyData();
    final (spawnX, spawnY) = MathUtils.randomPointOnCircle(
      center.x,
      center.y,
      spawnRadius,
      _random,
    );

    final enemy = EnemyComponent(
      data: enemyData,
      position: Vector2(spawnX, spawnY),
      targetPosition: center,
      onReachTarget: () => _onEnemyReachPlayer(enemyData),
      getTypingState: () => typingState.state,
    );

    _enemies[enemyData.id] = enemy;
    world.add(enemy);
  }

  void _onEnemyReachPlayer(EnemyData data) {
    // Проверяем что враг ещё существует
    if (!_enemies.containsKey(data.id)) return;
    
    interactor.onEnemyCollision(data.id, data.damage);
    _removeEnemy(data.id);
  }

  void _onEnemyKilled(String enemyId) {
    final enemy = _enemies[enemyId];
    if (enemy == null) return;
    
    enemy.playDeathEffect();
    // Удаляем из map сразу, но компонент сам удалится после эффекта
    _enemies.remove(enemyId);
  }

  void _removeEnemy(String enemyId) {
    final enemy = _enemies.remove(enemyId);
    enemy?.removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer?.update(dt);

    if (gameState.state.isPlaying && _mousePosition != null && _player != null) {
      _updateAiming();
    }
  }

  void _updateAiming() {
    if (_mousePosition == null || _player == null) return;

    // Угол от игрока к курсору
    final playerAngle = MathUtils.angleBetweenPoints(
      center.x,
      center.y,
      _mousePosition!.x,
      _mousePosition!.y,
    );

    _player!.setAngle(playerAngle);

    // Ищем врага под прицелом (копируем entries чтобы избежать concurrent modification)
    String? targetId;
    double closestDistance = double.infinity;

    for (final entry in _enemies.entries.toList()) {
      final enemy = entry.value;
      final enemyAngle = MathUtils.angleBetweenPoints(
        center.x,
        center.y,
        enemy.position.x,
        enemy.position.y,
      );

      if (MathUtils.isAngleWithinTolerance(playerAngle, enemyAngle, aimTolerance)) {
        final distance = MathUtils.distanceBetweenPoints(
          center.x,
          center.y,
          enemy.position.x,
          enemy.position.y,
        );

        if (distance < closestDistance) {
          closestDistance = distance;
          targetId = entry.key;
        }
      }
    }

    // Обновляем выделение
    _updateTargetHighlight(targetId);
  }

  void _updateTargetHighlight(String? newTargetId) {
    final currentTargetId = gameState.state.targetEnemyId;

    if (newTargetId != currentTargetId) {
      // Снимаем выделение с предыдущей цели
      if (currentTargetId != null) {
        _enemies[currentTargetId]?.setHighlighted(false);
      }

      // Устанавливаем новую цель
      if (newTargetId != null) {
        final enemy = _enemies[newTargetId];
        if (enemy != null) {
          enemy.setHighlighted(true);
          interactor.selectTarget(newTargetId, enemy.data.word);
        }
      } else {
        interactor.clearTarget();
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // Обрабатываем только нажатия клавиш (не отпускания)
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    // ESC - пауза/возврат в меню
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (gameState.state.isPlaying) {
        interactor.pauseGame();
        overlays.add('PauseMenu');
      } else if (gameState.state.isPaused) {
        overlays.remove('PauseMenu');
        interactor.resumeGame();
      }
      return KeyEventResult.handled;
    }

    // Обрабатываем ввод символов только во время игры
    if (!gameState.state.isPlaying) {
      return KeyEventResult.ignored;
    }

    // Обработка пробела
    if (event.logicalKey == LogicalKeyboardKey.space) {
      interactor.onCharacterTyped(' ');
      return KeyEventResult.handled;
    }

    // Получаем символ из события
    final char = event.character;
    if (char != null && char.isNotEmpty) {
      // Фильтруем только буквы
      if (RegExp(r'^[a-zA-Zа-яА-ЯёЁ]$').hasMatch(char)) {
        interactor.onCharacterTyped(char);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    _mousePosition = info.eventPosition.global;
  }

  /// Вернуться в главное меню
  void returnToMenu() {
    overlays.remove('GameOver');
    overlays.remove('HUD');
    overlays.remove('PauseMenu');
    overlays.add('MainMenu');

    // Очищаем врагов (копируем список)
    final enemiesToRemove = _enemies.values.toList();
    for (final enemy in enemiesToRemove) {
      enemy.removeFromParent();
    }
    _enemies.clear();

    interactor.returnToMenu();
    resumeEngine();
  }
}
