/// Бизнес-состояние пользовательского ввода
class InputState {
  final double? mouseX;
  final double? mouseY;

  const InputState({
    this.mouseX,
    this.mouseY,
  });

  ({double x, double y})? get mousePosition {
    final x = mouseX;
    final y = mouseY;
    if (x == null || y == null) return null;
    return (x: x, y: y);
  }

  InputState copyWith({
    double? mouseX,
    double? mouseY,
  }) {
    return InputState(
      mouseX: mouseX ?? this.mouseX,
      mouseY: mouseY ?? this.mouseY,
    );
  }
}
