import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../shared/models/game_config.dart';
import '../state/game_state.dart';

/// StateManager для управления бизнес-состоянием игры
class GameStateManager extends StateManager<GameState>
    implements AsyncLifecycle {
  final GameConfig _config;

  GameStateManager({required GameConfig config})
    : _config = config,
      super(const GameState());

  @override
  Future<void> init() async {
    // Инициализация при необходимости
  }

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Начать игру
  Future<void> startGame() => handle((emit) async {
    emit(
      GameState(
        health: _config.playerMaxHealth,
        maxHealth: _config.playerMaxHealth,
        status: GameStatus.playing,
      ),
    );
  });

  /// Поставить на паузу
  Future<void> pause() => handle((emit) async {
    if (state.isPlaying) {
      emit(state.copyWith(status: GameStatus.paused));
    }
  });

  /// Продолжить игру
  Future<void> resume() => handle((emit) async {
    if (state.isPaused) {
      emit(state.copyWith(status: GameStatus.playing));
    }
  });

  /// Добавить очки
  Future<void> addScore(int points) => handle((emit) async {
    emit(state.copyWith(score: state.score + points));
  });

  /// Увеличить счётчик убитых врагов
  Future<void> incrementKillCount() => handle((emit) async {
    final newKillCount = state.enemiesKilled + 1;
    final isWin = newKillCount >= _config.winKillCount;

    emit(
      state.copyWith(
        enemiesKilled: newKillCount,
        status: isWin ? GameStatus.win : state.status,
      ),
    );
  });

  /// Получить урон
  Future<void> takeDamage(int damage) => handle((emit) async {
    final newHealth = (state.health - damage).clamp(0, state.maxHealth);
    final isGameOver = newHealth <= 0;

    emit(
      state.copyWith(
        health: newHealth,
        status: isGameOver ? GameStatus.gameOver : state.status,
      ),
    );
  });

  /// Установить текущую цель (выделенный враг)
  Future<void> setTarget(String? enemyId) => handle((emit) async {
    if (enemyId == null) {
      emit(state.copyWith(clearTarget: true));
    } else {
      emit(state.copyWith(targetEnemyId: enemyId));
    }
  });

  /// Вернуться в меню
  Future<void> returnToMenu() => handle((emit) async {
    emit(const GameState());
  });
}
