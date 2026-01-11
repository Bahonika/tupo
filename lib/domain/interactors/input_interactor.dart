import 'package:yx_state/yx_state.dart';

import '../state/game_state.dart';
import '../state_managers/input_state_manager.dart';
import 'game_interactor.dart';

/// Результат обработки клавиатурного ввода
enum KeyInputResult {
  handled,
  ignored,
}

/// Interactor для обработки пользовательского ввода
class InputInteractor {
  final StateReadable<GameState> _gameState;
  final GameInteractor _gameInteractor;
  final InputStateManager _inputState;

  InputInteractor({
    required StateReadable<GameState> gameState,
    required GameInteractor gameInteractor,
    required InputStateManager inputState,
  })  : _gameState = gameState,
        _gameInteractor = gameInteractor,
        _inputState = inputState;

  void onMouseMove(double x, double y) {
    _inputState.updateMousePosition(x, y);
  }

  KeyInputResult onEscapePressed() {
    if (_gameState.state.isPlaying) {
      _gameInteractor.pauseGame();
      return KeyInputResult.handled;
    } else if (_gameState.state.isPaused) {
      _gameInteractor.resumeGame();
      return KeyInputResult.handled;
    }
    return KeyInputResult.ignored;
  }

  KeyInputResult onCharacterInput(String char) {
    if (!_gameState.state.isPlaying) {
      return KeyInputResult.ignored;
    }

    _gameInteractor.onCharacterTyped(char);
    return KeyInputResult.handled;
  }
}
