import 'dart:math';

import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../data/repositories/word_repository.dart';
import '../../shared/models/game_config.dart';
import '../../shared/models/settings.dart';
import '../models/active_enemy.dart';
import '../models/enemy_data.dart';
import '../state/enemies_state.dart';

/// StateManager для управления состоянием врагов
class EnemiesStateManager extends StateManager<EnemiesState>
    implements AsyncLifecycle {
  final WordRepository _wordRepository;
  final GameConfig _config;

  final Random _random = Random();

  EnemiesStateManager({
    required WordRepository wordRepository,
    required GameConfig config,
  })  : _wordRepository = wordRepository,
        _config = config,
        super(const EnemiesState());

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {
    await close();
  }

  /// Добавить врага на поле
  Future<void> addEnemy(String id, ActiveEnemy enemy) => handle((emit) async {
        final updated = Map<String, ActiveEnemy>.from(state.activeEnemies);
        updated[id] = enemy;
        emit(state.copyWith(activeEnemies: updated));
      });

  /// Обновить всех врагов
  Future<void> updateEnemies(Map<String, ActiveEnemy> enemies) =>
      handle((emit) async {
        emit(state.copyWith(activeEnemies: enemies));
      });

  /// Обновить конкретного врага
  Future<void> updateEnemy(String id, ActiveEnemy enemy) =>
      handle((emit) async {
        final updated = Map<String, ActiveEnemy>.from(state.activeEnemies);
        updated[id] = enemy;
        emit(state.copyWith(activeEnemies: updated));
      });

  /// Пометить врага как уничтоженного
  Future<void> markEnemyDestroyed(String id) => handle((emit) async {
        final enemy = state.activeEnemies[id];
        if (enemy == null) return;

        final updated = Map<String, ActiveEnemy>.from(state.activeEnemies);
        updated[id] = enemy.copyWith(isDestroyed: true);
        emit(state.copyWith(
          activeEnemies: updated,
          lastKilledEnemyId: id,
        ));
      });

  /// Удалить врага с поля
  Future<void> removeEnemy(String id) => handle((emit) async {
        final updated = Map<String, ActiveEnemy>.from(state.activeEnemies);
        updated.remove(id);
        emit(state.copyWith(activeEnemies: updated));
      });

  /// Очистить всех врагов
  Future<void> clearAllEnemies() => handle((emit) async {
        emit(state.copyWith(activeEnemies: const {}));
      });

  /// Сбросить уведомление об убийстве
  Future<void> clearLastKilled() => handle((emit) async {
        emit(state.copyWith(lastKilledEnemyId: null));
      });

  /// Уведомить о коллизии врага с игроком
  Future<void> notifyEnemyCollided(String enemyId) => handle((emit) async {
        emit(state.copyWith(lastCollidedEnemyId: enemyId));
      });

  /// Сбросить уведомление о коллизии
  Future<void> clearLastCollided() => handle((emit) async {
        emit(state.copyWith(lastCollidedEnemyId: null));
      });

  /// Запустить спавн врагов
  Future<void> startSpawning() => handle((emit) async {
        if (state.isSpawning) return;
        emit(state.copyWith(isSpawning: true));
      });

  /// Остановить спавн врагов
  Future<void> stopSpawning() => handle((emit) async {
        emit(state.copyWith(isSpawning: false));
      });

  /// Создать и добавить нового врага на поле
  Future<void> createAndSpawnEnemy({
    required double spawnX,
    required double spawnY,
    required double centerX,
    required double centerY,
    required Difficulty difficulty,
  }) =>
      handle((emit) async {
        final id = DateTime.now().microsecondsSinceEpoch.toString();

        String word;
        EnemyType type = EnemyType.normal;
        bool isBoss = false;

        switch (difficulty) {
          case Difficulty.easy:
            word = _wordRepository.getUniqueWord(useEasyWords: true);
            break;

          case Difficulty.medium:
            word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
            break;

          case Difficulty.hard:
            if (_random.nextInt(20) == 0) {
              word = _wordRepository.getUniquePhrase();
              type = EnemyType.special;
              isBoss = true;
            } else {
              word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
            }
            break;

          case Difficulty.extreme:
            final roll = _random.nextInt(100);
            if (roll < 5) {
              word = _wordRepository.getUniquePhrase();
              type = EnemyType.special;
              isBoss = true;
            } else if (roll < 15) {
              word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
              type = EnemyType.wavy;
            } else {
              word = _wordRepository.getUniqueWord(minLength: 3, maxLength: 10);
            }
            break;
        }

        final baseSpeedMultiplier = 1.0 + (10 - word.length) * 0.1;
        final bossSpeedMultiplier = isBoss ? 0.8 : 1.0;
        final speedMultiplier = baseSpeedMultiplier * bossSpeedMultiplier;
        final speed = _config.enemySpeedBase * speedMultiplier;

        final baseDamage = 5 + word.length * 2;
        final damage = isBoss ? (baseDamage * 1.5).round() : baseDamage;

        final enemyData = EnemyData(
          id: id,
          word: word,
          speed: speed,
          damage: damage,
          type: type,
        );

        final movementType = switch (enemyData.type) {
          EnemyType.wavy => MovementType.wavy,
          _ => MovementType.straight,
        };

        final enemy = ActiveEnemy(
          data: enemyData,
          x: spawnX,
          y: spawnY,
          targetX: centerX,
          targetY: centerY,
          startX: spawnX,
          startY: spawnY,
          movementType: movementType,
        );

        final updated = Map<String, ActiveEnemy>.from(state.activeEnemies);
        updated[id] = enemy;
        emit(state.copyWith(activeEnemies: updated));
      });
}
