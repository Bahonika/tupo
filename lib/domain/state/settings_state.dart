import '../../shared/models/settings.dart';

/// Состояние настроек
class SettingsState {
  final Settings settings;
  final bool isLoading;
  final bool isSaving;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.isSaving = false,
  });

  SettingsState copyWith({
    Settings? settings,
    bool? isLoading,
    bool? isSaving,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.settings == settings &&
        other.isLoading == isLoading &&
        other.isSaving == isSaving;
  }

  @override
  int get hashCode => Object.hash(settings, isLoading, isSaving);
}
