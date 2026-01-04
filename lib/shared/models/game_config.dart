/// Конфигурация игры — параметры для балансировки
class GameConfig {
  final double enemySpeedBase;
  final double enemySpeedMultiplier;
  final Duration spawnInterval;
  final int maxEnemies;
  final int playerMaxHealth;
  final int winKillCount;

  /// Для комбо системы (позже)
  final double comboMultiplier;
  final Duration comboWindow;

  const GameConfig({
    this.enemySpeedBase = 50.0,
    this.enemySpeedMultiplier = 1.0,
    this.spawnInterval = const Duration(seconds: 2),
    this.maxEnemies = 10,
    this.playerMaxHealth = 100,
    this.winKillCount = 50,
    this.comboMultiplier = 1.5,
    this.comboWindow = const Duration(seconds: 2),
  });

  GameConfig copyWith({
    double? enemySpeedBase,
    double? enemySpeedMultiplier,
    Duration? spawnInterval,
    int? maxEnemies,
    int? playerMaxHealth,
    int? winKillCount,
    double? comboMultiplier,
    Duration? comboWindow,
  }) {
    return GameConfig(
      enemySpeedBase: enemySpeedBase ?? this.enemySpeedBase,
      enemySpeedMultiplier: enemySpeedMultiplier ?? this.enemySpeedMultiplier,
      spawnInterval: spawnInterval ?? this.spawnInterval,
      maxEnemies: maxEnemies ?? this.maxEnemies,
      playerMaxHealth: playerMaxHealth ?? this.playerMaxHealth,
      winKillCount: winKillCount ?? this.winKillCount,
      comboMultiplier: comboMultiplier ?? this.comboMultiplier,
      comboWindow: comboWindow ?? this.comboWindow,
    );
  }
}
