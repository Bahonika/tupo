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
      const GameState(status: GameStatus.playing),
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

  /// Установить статус game over
  Future<void> setGameOver() => handle((emit) async {
    emit(state.copyWith(status: GameStatus.gameOver));
  });

  /// Вернуться в меню
  Future<void> returnToMenu() => handle((emit) async {
    emit(const GameState());
  });
}
