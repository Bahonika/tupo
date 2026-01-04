import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/enemy_data.dart';
import '../../../domain/state/typing_state.dart';
import '../../../shared/utils/math_utils.dart';
import 'colored_text_component.dart';
import 'enemy_movement.dart';

/// Компонент врага — движется к игроку, имеет слово-метку
class EnemyComponent extends PositionComponent {
  final EnemyData data;
  final Vector2 targetPosition;
  final VoidCallback onReachTarget;
  final TypingState? Function()? getTypingState;

  EnemyComponent({
    required this.data,
    required Vector2 position,
    required this.targetPosition,
    required this.onReachTarget,
    this.getTypingState,
  })  : _movement = _createMovement(data.type, position, targetPosition),
        _bodyPaint = Paint()
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
          position: position,
          size: Vector2.all(40),
          anchor: Anchor.center,
        );

  static const double _bodyRadius = 18;
  static const double _collisionRadius = 30;

  final Paint _bodyPaint;
  final Paint _bodyShadowPaint;
  final Paint _highlightPaint;

  bool _isHighlighted = false;
  bool _hasReachedTarget = false;
  bool _isDestroyed = false;
  final EnemyMovement _movement;
  ColoredTextComponent? _wordLabel;

  /// Создать объект движения на основе типа врага
  static EnemyMovement _createMovement(
    EnemyType type,
    Vector2 startPosition,
    Vector2 targetPosition,
  ) {
    switch (type) {
      case EnemyType.wavy:
        return WavyMovement(
          startPosition: startPosition,
          targetPosition: targetPosition,
        );
      case EnemyType.normal:
      case EnemyType.fast:
      case EnemyType.tank:
      case EnemyType.special:
        return StraightMovement(
          startPosition: startPosition,
          targetPosition: targetPosition,
        );
    }
  }

  static Color _getColorForType(EnemyType type) {
    switch (type) {
      case EnemyType.normal:
        return const Color(0xFFE8A8A8);
      case EnemyType.fast:
        return const Color(0xFFE8C8A8);
      case EnemyType.tank:
        return const Color(0xFFD4B8E8);
      case EnemyType.special:
        return const Color(0xFFB8D4D8);
      case EnemyType.wavy:
        return const Color(0xFFA8E8C8);
    }
  }

  @override
  Future<void> onLoad() async {
    // Создаём текстовую метку со словом
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
  }

  /// Установить выделение (прицеливание)
  void setHighlighted(bool highlighted) {
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

  /// Воспроизвести эффект уничтожения
  void playDeathEffect() {
    if (_isDestroyed) return;
    _isDestroyed = true;

    // Эффект масштабирования
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2),
      ),
    );

    // Удаление после эффекта
    add(
      RemoveEffect(delay: 0.2),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Не обновляем если уже достигли цели или уничтожены
    if (_hasReachedTarget || _isDestroyed) return;

    // Двигаемся к цели используя систему движения
    position = _movement.updatePosition(
      position,
      targetPosition,
      data.speed,
      dt,
    );

    // Обновляем индикацию ввода если это текущая цель
    if (_wordLabel != null && getTypingState != null) {
      final typingState = getTypingState!();
      if (typingState != null &&
          typingState.hasTarget &&
          typingState.targetWord.toLowerCase() == data.word.toLowerCase()) {
        _wordLabel!.typedChars = typingState.typedChars;
      } else {
        _wordLabel!.typedChars = 0;
      }
    }

    // Проверяем достижение цели
    final distance = MathUtils.distanceBetweenPoints(
      position.x,
      position.y,
      targetPosition.x,
      targetPosition.y,
    );

    if (distance < _collisionRadius) {
      _hasReachedTarget = true;
      onReachTarget();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Не рендерим если уничтожен (для эффекта затухания)
    if (_isDestroyed) return;

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    // Рисуем выделение если прицелены (мягкое кольцо)
    if (_isHighlighted) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        _bodyRadius + 6,
        _highlightPaint,
      );
    }

    // Рисуем тень
    _drawHexagon(
      canvas,
      Offset(centerX, centerY + 2),
      _bodyRadius,
      _bodyShadowPaint,
    );

    // Рисуем тело врага (мягкий шестиугольник для более геометричного вида)
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
