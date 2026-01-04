import 'dart:math' as math;

import 'package:flame/components.dart';

/// Абстрактный класс для различных типов движения врагов
abstract class EnemyMovement {
  /// Обновить позицию врага на основе времени и параметров
  /// 
  /// [currentPosition] - текущая позиция врага
  /// [targetPosition] - целевая позиция (центр экрана)
  /// [speed] - скорость движения
  /// [dt] - время с последнего обновления
  /// 
  /// Возвращает новую позицию врага
  Vector2 updatePosition(
    Vector2 currentPosition,
    Vector2 targetPosition,
    double speed,
    double dt,
  );
}

/// Прямолинейное движение к цели (для обычных врагов)
class StraightMovement extends EnemyMovement {
  final Vector2 _direction;

  StraightMovement({
    required Vector2 startPosition,
    required Vector2 targetPosition,
  }) : _direction = (targetPosition - startPosition).normalized();

  @override
  Vector2 updatePosition(
    Vector2 currentPosition,
    Vector2 targetPosition,
    double speed,
    double dt,
  ) {
    return currentPosition + _direction * speed * dt;
  }
}

/// Волнообразное движение по синусоиде (для wavy врагов)
class WavyMovement extends EnemyMovement {
  final Vector2 _baseDirection;
  final Vector2 _perpendicularDirection;
  final double _initialDistance;
  
  double _time = 0.0;
  final double maxAmplitude; // Максимальная амплитуда волны (на дальнем расстоянии)
  final double minAmplitude; // Минимальная амплитуда волны (близко к центру)
  final double frequency;

  WavyMovement({
    required Vector2 startPosition,
    required Vector2 targetPosition,
    this.maxAmplitude = 240.0, // Максимальная амплитуда на дальнем расстоянии
    this.minAmplitude = 5.0, // Минимальная амплитуда близко к центру
    this.frequency = 0.4, // Частота в Гц
  })  : _baseDirection = (targetPosition - startPosition).normalized(),
        _perpendicularDirection = _calculatePerpendicular(
          startPosition,
          targetPosition,
        ),
        _initialDistance = (targetPosition - startPosition).length;

  /// Вычислить перпендикулярное направление для волны
  static Vector2 _calculatePerpendicular(
    Vector2 start,
    Vector2 target,
  ) {
    final direction = (target - start).normalized();
    // Перпендикулярный вектор (поворот на 90 градусов)
    return Vector2(-direction.y, direction.x);
  }

  @override
  Vector2 updatePosition(
    Vector2 currentPosition,
    Vector2 targetPosition,
    double speed,
    double dt,
  ) {
    _time += dt;
    
    // Вычисляем текущее расстояние до цели
    final currentDistance = (targetPosition - currentPosition).length;
    
    // Амплитуда зависит от расстояния: чем дальше, тем больше амплитуда
    // Используем линейную интерполяцию от maxAmplitude (на начальном расстоянии) 
    // до minAmplitude (близко к центру)
    final distanceRatio = currentDistance / _initialDistance;
    final dynamicAmplitude = minAmplitude + 
        (maxAmplitude - minAmplitude) * distanceRatio.clamp(0.0, 1.0);
    
    // Базовое движение к цели
    final baseMovement = _baseDirection * speed * dt;
    
    // Волнообразное отклонение: используем производную синуса (косинус) для скорости
    // Скорость перпендикулярного движения = производная от sin(t) = cos(t) * frequency * 2π * amplitude
    final waveSpeed = math.cos(_time * frequency * 2 * math.pi) * 
                     frequency * 2 * math.pi * dynamicAmplitude;
    final waveMovement = _perpendicularDirection * waveSpeed * dt;
    
    return currentPosition + baseMovement + waveMovement;
  }
}
