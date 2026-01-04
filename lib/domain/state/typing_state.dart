/// Состояние набора текста
class TypingState {
  /// Слово текущей цели
  final String targetWord;

  /// Количество правильно введённых символов
  final int typedChars;

  /// Флаг последней ошибки (для визуальной обратной связи)
  final bool lastError;

  const TypingState({
    this.targetWord = '',
    this.typedChars = 0,
    this.lastError = false,
  });

  /// Есть ли активная цель для набора
  bool get hasTarget => targetWord.isNotEmpty;

  /// Слово полностью набрано
  bool get isComplete => hasTarget && typedChars >= targetWord.length;

  /// Оставшиеся символы для набора
  int get remainingChars => targetWord.length - typedChars;

  /// Прогресс набора (0.0 - 1.0)
  double get progress =>
      targetWord.isEmpty ? 0.0 : typedChars / targetWord.length;

  /// Уже набранная часть слова
  String get typedPart =>
      targetWord.isEmpty ? '' : targetWord.substring(0, typedChars);

  /// Оставшаяся часть слова
  String get remainingPart =>
      targetWord.isEmpty ? '' : targetWord.substring(typedChars);

  /// Следующий ожидаемый символ
  String? get nextExpectedChar =>
      isComplete || targetWord.isEmpty ? null : targetWord[typedChars];

  TypingState copyWith({
    String? targetWord,
    int? typedChars,
    bool? lastError,
  }) {
    return TypingState(
      targetWord: targetWord ?? this.targetWord,
      typedChars: typedChars ?? this.typedChars,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypingState &&
        other.targetWord == targetWord &&
        other.typedChars == typedChars &&
        other.lastError == lastError;
  }

  @override
  int get hashCode => Object.hash(targetWord, typedChars, lastError);

  @override
  String toString() =>
      'TypingState(word: "$targetWord", typed: $typedChars, error: $lastError)';
}
