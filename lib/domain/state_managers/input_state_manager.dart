import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../state/input_state.dart';

/// StateManager для управления состоянием пользовательского ввода
class InputStateManager extends StateManager<InputState>
    implements AsyncLifecycle {
  InputStateManager() : super(const InputState());

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {
    await close();
  }

  Future<void> updateMousePosition(double x, double y) => handle((emit) async {
    emit(state.copyWith(mouseX: x, mouseY: y));
  });
}
