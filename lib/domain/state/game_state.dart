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
class GameState {
  final int health;
  final int maxHealth;
  final int score;
  final int enemiesKilled;
  final GameStatus status;
  final String? targetEnemyId;

  const GameState({
    this.health = 100,
    this.maxHealth = 100,
    this.score = 0,
    this.enemiesKilled = 0,
    this.status = GameStatus.menu,
    this.targetEnemyId,
  });

  bool get isPlaying => status == GameStatus.playing;
  bool get isGameOver => status == GameStatus.gameOver;
  bool get isWin => status == GameStatus.win;
  bool get isMenu => status == GameStatus.menu;
  bool get isPaused => status == GameStatus.paused;
  bool get hasTarget => targetEnemyId != null;

  /// Процент здоровья (0.0 - 1.0)
  double get healthPercent => health / maxHealth;

  GameState copyWith({
    int? health,
    int? maxHealth,
    int? score,
    int? enemiesKilled,
    GameStatus? status,
    String? targetEnemyId,
    bool clearTarget = false,
  }) {
    return GameState(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      score: score ?? this.score,
      enemiesKilled: enemiesKilled ?? this.enemiesKilled,
      status: status ?? this.status,
      targetEnemyId: clearTarget ? null : (targetEnemyId ?? this.targetEnemyId),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameState &&
        other.health == health &&
        other.maxHealth == maxHealth &&
        other.score == score &&
        other.enemiesKilled == enemiesKilled &&
        other.status == status &&
        other.targetEnemyId == targetEnemyId;
  }

  @override
  int get hashCode => Object.hash(
        health,
        maxHealth,
        score,
        enemiesKilled,
        status,
        targetEnemyId,
      );

  @override
  String toString() =>
      'GameState(health: $health/$maxHealth, score: $score, killed: $enemiesKilled, status: $status, target: $targetEnemyId)';
}
