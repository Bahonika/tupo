/// Состояние набора текста
class TypingState {
  /// Количество правильно введённых символов
  final int typedChars;

  /// Флаг последней ошибки (для визуальной обратной связи)
  final bool lastError;

  const TypingState({
    this.typedChars = 0,
    this.lastError = false,
  });

  TypingState copyWith({
    int? typedChars,
    bool? lastError,
  }) {
    return TypingState(
      typedChars: typedChars ?? this.typedChars,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypingState &&
        other.typedChars == typedChars &&
        other.lastError == lastError;
  }

  @override
  int get hashCode => Object.hash(typedChars, lastError);

  @override
  String toString() =>
      'TypingState(typed: $typedChars, error: $lastError)';
}
