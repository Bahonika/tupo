import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/typing_state.dart';

/// Результат обработки символа
enum TypingResult {
  /// Символ правильный
  correct,

  /// Символ неправильный
  error,

  /// Слово полностью набрано
  complete,

  /// Нет активной цели
  noTarget,
}

/// StateManager для управления состоянием набора текста
class TypingStateManager extends StateManager<TypingState>
    implements AsyncLifecycle {
  TypingStateManager() : super(const TypingState());

  @override
  Future<void> init() async {
    // Инициализация при необходимости
  }

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Сбросить состояние набора
  Future<void> reset() => handle((emit) async {
        emit(const TypingState());
      });

  /// Обработать введённый символ
  /// Возвращает результат обработки
  Future<TypingResult> processChar(String char, String targetWord) async {
    if (targetWord.isEmpty) {
      return TypingResult.noTarget;
    }

    final normalizedTargetWord = targetWord.toLowerCase();
    final expectedCharIndex = state.typedChars;
    if (expectedCharIndex >= normalizedTargetWord.length) {
      return TypingResult.noTarget;
    }

    final expectedChar = normalizedTargetWord[expectedCharIndex];

    // Для пробелов сравниваем как есть, для букв - приводим к нижнему регистру
    final normalizedChar = char == ' ' ? ' ' : char.toLowerCase();
    final normalizedExpected = expectedChar == ' ' ? ' ' : expectedChar.toLowerCase();

    if (normalizedChar == normalizedExpected) {
      final newTypedChars = state.typedChars + 1;
      final isComplete = newTypedChars >= normalizedTargetWord.length;

      await handle((emit) async {
        emit(state.copyWith(
          typedChars: newTypedChars,
          lastError: false,
        ));
      });

      return isComplete ? TypingResult.complete : TypingResult.correct;
    } else {
      // Ошибка — сбрасываем прогресс
      await handle((emit) async {
        emit(state.copyWith(
          typedChars: 0,
          lastError: true,
        ));
      });

      return TypingResult.error;
    }
  }

  /// Сбросить флаг ошибки (для визуальной обратной связи)
  Future<void> clearError() => handle((emit) async {
        if (state.lastError) {
          emit(state.copyWith(lastError: false));
        }
      });
}
