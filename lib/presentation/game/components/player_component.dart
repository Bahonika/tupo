import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:yx_state/yx_state.dart';

import '../../../domain/state/player_state.dart';
import 'state_listener_component.dart';

/// Компонент для визуального эффекта урона
class _DamageEffectComponent extends Component {
  double _progress = 1.0;
  static const double _duration = 0.3;

  @override
  void update(double dt) {
    super.update(dt);
    _progress = (_progress - dt / _duration).clamp(0.0, 1.0);
    if (_progress <= 0) {
      removeFromParent();
    }
  }

  double get intensity => _progress;
}

/// Компонент игрока — статичный объект в центре экрана с вращением
class PlayerComponent extends PositionComponent {
  final StateReadable<PlayerState> playerState;

  PlayerComponent({
    required this.playerState,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(60),
          anchor: Anchor.center,
        );

  static const double _bodyRadius = 22;
  static const double _pointerLength = 30;
  static const double _pointerWidth = 4;

  final Paint _bodyPaint = Paint()
    ..color = const Color(0xFFB8D4D8)
    ..style = PaintingStyle.fill;
  final Paint _bodyShadowPaint = Paint()
    ..color = const Color(0xFF8FA8B2).withOpacity(0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  final Paint _pointerPaint = Paint()
    ..color = const Color(0xFF6B8E9F)
    ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    // Используем реактивный компонент для отслеживания урона
    // Фильтруем только изменения health, чтобы не реагировать на другие изменения состояния
    add(StateListenerComponent<PlayerState>(
      stateReadable: playerState,
      listenWhen: (previous, current) => previous.health != current.health,
      listener: (previous, current) {
        // Запускаем эффект только при уменьшении health (урон)
        if (current.health < previous.health) {
          // Проверяем наличие эффекта через children
          final hasEffect = children.whereType<_DamageEffectComponent>().isNotEmpty;
          if (!hasEffect) {
            add(_DamageEffectComponent());
          }
        }
      },
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    // Сохраняем состояние canvas
    canvas.save();

    // Перемещаемся в центр и вращаем
    canvas.translate(centerX, centerY);
    canvas.rotate(playerState.state.angle);

    // Получаем интенсивность эффекта урона из дочернего компонента
    final damageEffects = children.whereType<_DamageEffectComponent>();
    final damageEffect = damageEffects.isNotEmpty ? damageEffects.first : null;
    final intensity = damageEffect?.intensity ?? 0.0;

    // Применяем эффект покраснения при уроне через смешивание цветов
    // Используем Color.lerp для смешивания с красным цветом
    final redTint = intensity > 0 ? Colors.red.withOpacity(intensity * 0.6) : null;

    // Рисуем тень тела
    Paint shadowPaint = _bodyShadowPaint;
    if (redTint != null) {
      shadowPaint = Paint()
        ..color = Color.lerp(_bodyShadowPaint.color, redTint, intensity)!
        ..maskFilter = _bodyShadowPaint.maskFilter;
    }
    canvas.drawCircle(
      Offset(0, 2),
      _bodyRadius,
      shadowPaint,
    );

    // Рисуем тело (мягкий круг)
    Paint bodyPaint = _bodyPaint;
    if (redTint != null) {
      bodyPaint = Paint()
        ..color = Color.lerp(_bodyPaint.color, redTint, intensity)!
        ..style = _bodyPaint.style;
    }
    canvas.drawCircle(Offset.zero, _bodyRadius, bodyPaint);

    // Рисуем указатель направления (стрелка)
    final path = Path();
    path.moveTo(_bodyRadius, 0);
    path.lineTo(
      _bodyRadius + _pointerLength,
      -_pointerWidth / 2,
    );
    path.lineTo(
      _bodyRadius + _pointerLength,
      _pointerWidth / 2,
    );
    path.close();
    Paint pointerPaint = _pointerPaint;
    if (redTint != null) {
      pointerPaint = Paint()
        ..color = Color.lerp(_pointerPaint.color, redTint, intensity)!
        ..style = _pointerPaint.style;
    }
    canvas.drawPath(path, pointerPaint);

    // Восстанавливаем состояние canvas
    canvas.restore();
  }
}
