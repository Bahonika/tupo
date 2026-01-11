import 'dart:async';

import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../data/sources/localization_source.dart';
import '../../shared/models/settings.dart';
import '../state/settings_state.dart';
import '../state_managers/localization_state_manager.dart';

export '../../data/sources/localization_source.dart' show LocalizationKey;

/// Interactor для локализации UI
class LocalizationInteractor implements AsyncLifecycle {
  final LocalizationStateManager _localizationState;
  final StateReadable<SettingsState> _settingsState;
  final LocalizationSource _localizationSource;

  StreamSubscription<Language>? _languageSubscription;

  LocalizationInteractor(
    this._localizationState,
    this._settingsState,
    this._localizationSource,
  );

  @override
  Future<void> init() async {
    final currentLanguage = _settingsState.state.settings.language;
    await _localizationState.updateLanguage(currentLanguage);

    _languageSubscription ??= _settingsState.stream
        .map((state) => state.settings.language)
        .distinct()
        .listen((language) {
      _localizationState.updateLanguage(language);
    });
  }

  @override
  Future<void> dispose() async {
    await _languageSubscription?.cancel();
    _languageSubscription = null;
  }

  /// Получить перевод для ключа
  String translate(LocalizationKey key) {
    return _localizationSource.translate(
      key,
      _localizationState.state.currentLanguage,
    );
  }
}
