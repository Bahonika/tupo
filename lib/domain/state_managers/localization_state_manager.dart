import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../shared/models/settings.dart';
import '../state/localization_state.dart';

/// StateManager для управления состоянием локализации
class LocalizationStateManager extends StateManager<LocalizationState>
    implements AsyncLifecycle {
  LocalizationStateManager() : super(const LocalizationState());

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Обновить текущий язык
  Future<void> updateLanguage(Language language) => handle((emit) async {
    if (language != state.currentLanguage) {
      emit(state.copyWith(currentLanguage: language));
    }
  });
}
