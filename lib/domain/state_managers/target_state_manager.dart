import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/target_state.dart';

/// StateManager для управления состоянием цели
class TargetStateManager extends StateManager<TargetState>
    implements AsyncLifecycle {
  TargetStateManager() : super(const TargetState.none());

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Установить цель
  Future<void> setTarget(String enemyId, String word) => handle((emit) async {
        emit(TargetState.selected(enemyId: enemyId, word: word));
      });

  /// Сбросить цель
  Future<void> clearTarget() => handle((emit) async {
        emit(const TargetState.none());
      });
}
