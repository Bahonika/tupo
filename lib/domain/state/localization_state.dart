import '../../shared/models/settings.dart';

/// Состояние локализации
class LocalizationState {
  final Language currentLanguage;

  const LocalizationState({
    this.currentLanguage = Language.russian,
  });

  LocalizationState copyWith({
    Language? currentLanguage,
  }) {
    return LocalizationState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalizationState &&
        other.currentLanguage == currentLanguage;
  }

  @override
  int get hashCode => currentLanguage.hashCode;
}
