import 'dart:async';

import 'package:flame/components.dart';
import 'package:yx_state/yx_state.dart';

/// Flame-эквивалент StateListener из yx_state_flutter.
/// 
/// Компонент, который подписывается на изменения состояния и выполняет
/// side effects (callback) при изменении состояния.
/// 
/// Использование:
/// ```dart
/// class MyComponent extends Component {
///   @override
///   Future<void> onLoad() async {
///     add(StateListenerComponent<GameState>(
///       stateReadable: gameState,
///       listener: (previous, current) {
///         if (current.health < previous.health) {
///           // Выполнить side effect при уроне
///         }
///       },
///       listenWhen: (previous, current) => previous.health != current.health,
///     ));
///   }
/// }
/// ```
class StateListenerComponent<S> extends Component {
  /// Источник состояния для прослушивания
  final StateReadable<S> stateReadable;

  /// Callback, вызываемый при изменении состояния
  final void Function(S previous, S current) listener;

  /// Условие для фильтрации событий (опционально)
  /// Если null, listener вызывается при каждом изменении состояния
  final bool Function(S previous, S current)? listenWhen;

  StreamSubscription<S>? _subscription;
  S? _previousState;

  StateListenerComponent({
    required this.stateReadable,
    required this.listener,
    this.listenWhen,
  });

  @override
  Future<void> onLoad() async {
    _previousState = stateReadable.state;
    
    _subscription = stateReadable.stream.listen((currentState) {
      final previous = _previousState;
      
      // Пропускаем первое событие (инициализация)
      if (previous == null) {
        _previousState = currentState;
        return;
      }

      // Проверяем условие фильтрации
      if (listenWhen != null && !listenWhen!(previous, currentState)) {
        _previousState = currentState;
        return;
      }

      // Вызываем listener
      listener(previous, currentState);
      _previousState = currentState;
    });
  }

  @override
  void onRemove() {
    _subscription?.cancel();
    _subscription = null;
    _previousState = null;
    super.onRemove();
  }
}
