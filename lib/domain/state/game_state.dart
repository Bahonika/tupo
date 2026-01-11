import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

/// Статус игры
enum GameStatus {
  /// Главное меню
  menu,

  /// Игра идёт
  playing,

  /// Пауза
  paused,

  /// Игра окончена (поражение)
  gameOver,

  /// Победа
  win,
}

/// Бизнес-состояние игры
@freezed
sealed class GameState with _$GameState {
  const factory GameState({
    @Default(0) int score,
    @Default(0) int enemiesKilled,
    @Default(GameStatus.menu) GameStatus status,
  }) = _GameState;

  const GameState._();

  bool get isPlaying => status == GameStatus.playing;
  bool get isGameOver => status == GameStatus.gameOver;
  bool get isWin => status == GameStatus.win;
  bool get isMenu => status == GameStatus.menu;
  bool get isPaused => status == GameStatus.paused;
}
