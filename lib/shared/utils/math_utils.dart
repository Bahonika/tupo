import 'dart:math';

/// Чистые математические функции для игры
class MathUtils {
  MathUtils._();

  /// Расчёт угла между двумя точками (в радианах)
  static double angleBetweenPoints(
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    return atan2(y2 - y1, x2 - x1);
  }

  /// Расчёт дистанции между двумя точками
  static double distanceBetweenPoints(
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return sqrt(dx * dx + dy * dy);
  }

  /// Нормализация угла в диапазон [-PI, PI]
  static double normalizeAngle(double angle) {
    while (angle > pi) {
      angle -= 2 * pi;
    }
    while (angle < -pi) {
      angle += 2 * pi;
    }
    return angle;
  }

  /// Проверка, находится ли угол в пределах допуска
  /// [angle] - текущий угол
  /// [targetAngle] - целевой угол
  /// [tolerance] - допуск в радианах
  static bool isAngleWithinTolerance(
    double angle,
    double targetAngle,
    double tolerance,
  ) {
    final diff = normalizeAngle(angle - targetAngle).abs();
    return diff <= tolerance;
  }

  /// Генерация случайной точки на окружности
  /// [centerX], [centerY] - центр окружности
  /// [radius] - радиус окружности
  static (double x, double y) randomPointOnCircle(
    double centerX,
    double centerY,
    double radius,
    Random random,
  ) {
    final angle = random.nextDouble() * 2 * pi;
    final x = centerX + radius * cos(angle);
    final y = centerY + radius * sin(angle);
    return (x, y);
  }
}
