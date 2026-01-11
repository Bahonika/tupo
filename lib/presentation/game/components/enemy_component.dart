import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:yx_state/yx_state.dart';

import '../../../domain/models/enemy_data.dart';
import '../../../domain/state/enemies_state.dart';
import '../../../domain/state/target_state.dart';
import '../../../domain/state/typing_state.dart';
import 'colored_text_component.dart';
import 'state_listener_component.dart';

/// Компонент врага — визуальное представление, без бизнес-логики
class EnemyComponent extends PositionComponent {
  final String enemyId;
  final EnemyData data;
  final StateReadable<EnemiesState> enemiesState;
  final StateReadable<TypingState> typingState;
  final StateReadable<TargetState> targetState;

  EnemyComponent({
    required this.enemyId,
    required this.data,
    required Vector2 initialPosition,
    required this.enemiesState,
    required this.typingState,
    required this.targetState,
  })  : _bodyPaint = Paint()
          ..color = _getColorForType(data.type)
          ..style = PaintingStyle.fill,
        _bodyShadowPaint = Paint()
          ..color = _getColorForType(data.type).withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        _highlightPaint = Paint()
          ..color = const Color(0xFFD4A574)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
        super(
          position: initialPosition,
          size: Vector2.all(40),
          anchor: Anchor.center,
        );

  static const double _bodyRadius = 18;

  final Paint _bodyPaint;
  final Paint _bodyShadowPaint;
  final Paint _highlightPaint;

  bool _isHighlighted = false;
  ColoredTextComponent? _wordLabel;

  // Эфемерное состояние для анимации смерти
  bool _deathAnimationStarted = false;

  static Color _getColorForType(EnemyType type) {
    switch (type) {
      case EnemyType.normal:
        return const Color(0xFFE8A8A8);
      case EnemyType.special:
        return const Color(0xFFB8D4D8);
      case EnemyType.wavy:
        return const Color(0xFFA8E8C8);
    }
  }

  @override
  Future<void> onLoad() async {
    _wordLabel = ColoredTextComponent(
      fullText: data.word.toUpperCase(),
      typedChars: 0,
      typedColor: const Color(0xFF7FB89A),
      remainingColor: const Color(0xFF4A6B7A),
      baseStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      position: Vector2(size.x / 2, -25),
      anchor: Anchor.bottomCenter,
    );
    add(_wordLabel!);

    // Подписка на изменения позиции врага
    add(StateListenerComponent<EnemiesState>(
      stateReadable: enemiesState,
      listenWhen: (prev, curr) {
        final prevEnemy = prev.activeEnemies[enemyId];
        final currEnemy = curr.activeEnemies[enemyId];
        if (prevEnemy == null || currEnemy == null) {
          return currEnemy != prevEnemy;
        }
        return prevEnemy.x != currEnemy.x ||
            prevEnemy.y != currEnemy.y ||
            prevEnemy.isDestroyed != currEnemy.isDestroyed ||
            prevEnemy.hasReachedTarget != currEnemy.hasReachedTarget;
      },
      listener: (prev, curr) {
        final enemy = curr.activeEnemies[enemyId];
        if (enemy == null || enemy.hasReachedTarget) {
          removeFromParent();
          return;
        }

        position.x = enemy.x;
        position.y = enemy.y;

        if (enemy.isDestroyed && !_deathAnimationStarted) {
          _playDeathEffect();
        }
      },
    ));

    // Подписка на изменения цели для автоматического обновления подсветки
    add(StateListenerComponent<TargetState>(
      stateReadable: targetState,
      listenWhen: (prev, curr) {
        final prevId = prev.maybeWhen(selected: (id, _) => id, orElse: () => null);
        final currId = curr.maybeWhen(selected: (id, _) => id, orElse: () => null);
        return prevId != currId;
      },
      listener: (_, curr) {
        final currId = curr.maybeWhen(selected: (id, _) => id, orElse: () => null);
        _setHighlighted(currId == enemyId);
      },
    ));

    // Инициализация подсветки на основе текущего состояния
    final currentId = targetState.state.maybeWhen(
      selected: (id, _) => id,
      orElse: () => null,
    );
    _setHighlighted(currentId == enemyId);

    // Подписка на изменения состояния ввода для подсветки букв
    add(StateListenerComponent<TypingState>(
      stateReadable: typingState,
      listenWhen: (prev, curr) => prev.typedChars != curr.typedChars,
      listener: (prev, curr) {
        _updateTypedChars(curr);
      },
    ));
  }

  void _updateTypedChars(TypingState state) {
    if (_wordLabel == null) return;

    final targetWord = targetState.state.maybeWhen(
      selected: (_, word) => word,
      orElse: () => null,
    );
    if (targetWord != null &&
        targetWord.toLowerCase() == data.word.toLowerCase()) {
      _wordLabel!.typedChars = state.typedChars;
    } else {
      _wordLabel!.typedChars = 0;
    }
  }

  void _setHighlighted(bool highlighted) {
    if (_isHighlighted == highlighted) return;
    _isHighlighted = highlighted;

    final label = _wordLabel;
    if (label == null) return;

    if (highlighted) {
      label.baseStyle = label.baseStyle.copyWith(fontSize: 16);
      label.remainingColor = const Color(0xFFD4A574);
    } else {
      label.baseStyle = label.baseStyle.copyWith(fontSize: 14);
      label.remainingColor = const Color(0xFF4A6B7A);
    }
  }

  void _playDeathEffect() {
    _deathAnimationStarted = true;

    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2),
      ),
    );

    add(
      RemoveEffect(delay: 0.2),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_deathAnimationStarted) return;

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    if (_isHighlighted) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        _bodyRadius + 6,
        _highlightPaint,
      );
    }

    _drawHexagon(
      canvas,
      Offset(centerX, centerY + 2),
      _bodyRadius,
      _bodyShadowPaint,
    );

    _drawHexagon(canvas, Offset(centerX, centerY), _bodyRadius, _bodyPaint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
