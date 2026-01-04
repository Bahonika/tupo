import 'dart:math';

import '../../shared/models/settings.dart';
import '../sources/word_source.dart';

/// Репозиторий для работы со словами
class WordRepository {
  final WordSource _source;

  WordRepository({
    required WordSource source,
  }) : _source = source;

  final Random _random = Random();
  final Set<String> _usedWords = {};
  final Set<String> _usedPhrases = {};

  List<String>? _cachedWords;

  List<String> get _words => _cachedWords ??= _source.getAllWords();

  /// Обновить язык источника слов
  void updateLanguage(Language language) {
    if (language != _source.currentLanguage) {
      _source.setLanguage(language);
      _cachedWords = null; // Сбрасываем кэш
      resetUsedWords(); // Сбрасываем использованные слова
      resetUsedPhrases(); // Сбрасываем использованные фразы
    }
  }

  /// Получить случайное слово с опциональной фильтрацией по длине
  String getRandomWord({int? minLength, int? maxLength}) {
    var filtered = _words;

    if (minLength != null) {
      filtered = filtered.where((w) => w.length >= minLength).toList();
    }
    if (maxLength != null) {
      filtered = filtered.where((w) => w.length <= maxLength).toList();
    }

    if (filtered.isEmpty) {
      return _words[_random.nextInt(_words.length)];
    }

    return filtered[_random.nextInt(filtered.length)];
  }

  /// Получить N уникальных слов (без повторений в рамках сессии)
  List<String> getUniqueWords(int count, {int? minLength, int? maxLength, bool useEasyWords = false}) {
    final sourceWords = useEasyWords ? _source.getEasyWords() : _words;
    var filtered = sourceWords;

    if (minLength != null) {
      filtered = filtered.where((w) => w.length >= minLength).toList();
    }
    if (maxLength != null) {
      filtered = filtered.where((w) => w.length <= maxLength).toList();
    }

    // Исключаем уже использованные слова
    final available = filtered.where((w) => !_usedWords.contains(w)).toList();

    // Если слов не хватает, сбрасываем использованные
    if (available.length < count) {
      _usedWords.clear();
      return getUniqueWords(count, minLength: minLength, maxLength: maxLength, useEasyWords: useEasyWords);
    }

    available.shuffle(_random);
    final result = available.take(count).toList();
    _usedWords.addAll(result);

    return result;
  }

  /// Получить одно уникальное слово (без повторений в рамках сессии)
  String getUniqueWord({int? minLength, int? maxLength, bool useEasyWords = false}) {
    return getUniqueWords(1, minLength: minLength, maxLength: maxLength, useEasyWords: useEasyWords).first;
  }

  /// Получить одно уникальное словосочетание (без повторений в рамках сессии)
  String getUniquePhrase() {
    final phrases = _source.getAllPhrases();
    final available = phrases.where((p) => !_usedPhrases.contains(p)).toList();

    // Если фраз не хватает, сбрасываем использованные
    if (available.isEmpty) {
      _usedPhrases.clear();
      return getUniquePhrase();
    }

    available.shuffle(_random);
    final result = available.first;
    _usedPhrases.add(result);

    return result;
  }

  /// Сбросить список использованных слов
  void resetUsedWords() {
    _usedWords.clear();
  }

  /// Сбросить список использованных фраз
  void resetUsedPhrases() {
    _usedPhrases.clear();
  }
}
