import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../shared/models/game_config.dart';
import '../state/player_state.dart';

/// StateManager для управления состоянием персонажа
class PlayerStateManager extends StateManager<PlayerState>
    implements AsyncLifecycle {
  final GameConfig _config;

  PlayerStateManager({required GameConfig config})
      : _config = config,
        super(const PlayerState());

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Установить угол направления игрока
  Future<void> setAngle(double angle) => handle((emit) async {
        emit(state.copyWith(angle: angle));
      });

  /// Инициализировать здоровье при старте игры
  Future<void> initializeHealth() => handle((emit) async {
        emit(state.copyWith(
          health: _config.playerMaxHealth,
          maxHealth: _config.playerMaxHealth,
        ));
      });

  /// Получить урон
  Future<void> takeDamage(int damage) => handle((emit) async {
        final newHealth = (state.health - damage).clamp(0, state.maxHealth);
        emit(state.copyWith(health: newHealth));
      });

  /// Сбросить здоровье
  Future<void> resetHealth() => handle((emit) async {
        emit(const PlayerState());
      });
}
