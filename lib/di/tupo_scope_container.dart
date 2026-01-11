import 'package:flutter/foundation.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/repositories/word_repository.dart';
import '../data/sources/audio_service.dart';
import '../data/sources/localization_source.dart';
import '../data/sources/soloud_audio_service.dart';
import '../data/sources/web_audio_service.dart';
import '../data/sources/settings_storage.dart';
import '../data/sources/word_source.dart';
import '../domain/interactors/aiming_interactor.dart';
import '../domain/interactors/enemies_cleanup_interactor.dart';
import '../domain/interactors/enemy_movement_interactor.dart';
import '../domain/interactors/game_interactor.dart';
import '../domain/interactors/game_loop_interactor.dart';
import '../domain/interactors/input_interactor.dart';
import '../domain/interactors/localization_interactor.dart';
import '../domain/interactors/player_interactor.dart';
import '../domain/interactors/spawning_interactor.dart';
import '../domain/interactors/target_interactor.dart';
import '../domain/interactors/typing_interactor.dart';
import '../domain/state_managers/enemies_state_manager.dart';
import '../domain/state_managers/game_state_manager.dart';
import '../domain/state_managers/input_state_manager.dart';
import '../domain/state_managers/localization_state_manager.dart';
import '../domain/state_managers/player_state_manager.dart';
import '../domain/state_managers/settings_state_manager.dart';
import '../domain/state_managers/target_state_manager.dart';
import '../domain/state_managers/typing_state_manager.dart';
import '../shared/models/game_config.dart';
import 'tupo_scope.dart';

/// Container для зависимостей игры Tupo
class TupoScopeContainer extends ScopeContainer implements TupoScope {
  // Shared
  final _config = const GameConfig();

  // Data layer - sources
  late final _audioServiceDep = asyncDep<AudioService>(
    () => kIsWeb ? WebAudioService() : SoloudAudioService(),
  );
  late final _wordSourceDep = dep(() => WordSource());
  late final _settingsStorageDep = asyncDep(
    () => SharedPreferencesSettingsStorage(),
  );
  late final _localizationSourceDep = dep(() => LocalizationSource());

  // Data layer - repositories
  late final _wordRepositoryDep = dep(
    () => WordRepository(source: _wordSourceDep.get),
  );

  // Domain layer - state managers
  late final _gameStateDep = asyncDep(() => GameStateManager(config: _config));

  late final _targetStateDep = asyncDep(() => TargetStateManager());

  late final _typingStateDep = asyncDep(() => TypingStateManager());

  late final _enemiesStateDep = asyncDep(
    () => EnemiesStateManager(
      wordRepository: _wordRepositoryDep.get,
      config: _config,
    ),
  );

  late final _settingsStateDep = asyncDep(
    () => SettingsStateManager(_settingsStorageDep.get),
  );

  late final _localizationStateDep = asyncDep(() => LocalizationStateManager());

  late final _inputStateDep = asyncDep(() => InputStateManager());

  late final _playerStateDep = asyncDep(
    () => PlayerStateManager(config: _config),
  );

  // Domain layer - interactors
  late final _localizationInteractorDep = asyncDep(
    () => LocalizationInteractor(
      _localizationStateDep.get,
      _settingsStateDep.get,
      _localizationSourceDep.get,
    ),
  );

  late final _playerInteractorDep = asyncDep(
    () => PlayerInteractor(
      playerState: _playerStateDep.get,
      gameState: _gameStateDep.get,
    ),
  );

  late final _targetInteractorDep = asyncDep(
    () => TargetInteractor(
      targetState: _targetStateDep.get,
      typingState: _typingStateDep.get,
      gameState: _gameStateDep.get,
      enemiesState: _enemiesStateDep.get,
    ),
  );

  late final _typingInteractorDep = asyncDep(
    () => TypingInteractor(
      typingState: _typingStateDep.get,
      gameState: _gameStateDep.get,
    ),
  );

  late final _enemiesCleanupInteractorDep = asyncDep(
    () => EnemiesCleanupInteractor(
      gameState: _gameStateDep.get,
      enemiesState: _enemiesStateDep.get,
    ),
  );

  late final _gameInteractorDep = asyncDep(
    () => GameInteractor(
      gameState: _gameStateDep.get,
      typingState: _typingStateDep.get,
      enemiesState: _enemiesStateDep.get,
      wordRepository: _wordRepositoryDep.get,
      audioService: _audioServiceDep.get,
      settingsState: _settingsStateDep.get,
      targetState: _targetStateDep.get,
      playerState: _playerStateDep.get,
    ),
  );

  late final _enemyMovementInteractorDep = dep(
    () => EnemyMovementInteractor(
      enemiesState: _enemiesStateDep.get,
      playerState: _playerStateDep.get,
      audioService: _audioServiceDep.get,
    ),
  );

  late final _spawningInteractorDep = asyncDep(
    () => SpawningInteractor(
      gameState: _gameStateDep.get,
      enemiesState: _enemiesStateDep.get,
      settingsState: _settingsStateDep.get,
      config: _config,
    ),
  );

  late final _aimingInteractorDep = dep(
    () => AimingInteractor(
      playerState: _playerStateDep.get,
      targetState: _targetStateDep.get,
      typingState: _typingStateDep.get,
    ),
  );

  late final _gameLoopInteractorDep = dep(
    () => GameLoopInteractor(
      enemyMovementInteractor: _enemyMovementInteractorDep.get,
      spawningInteractor: _spawningInteractorDep.get,
      aimingInteractor: _aimingInteractorDep.get,
      inputState: _inputStateDep.get,
      enemiesState: _enemiesStateDep.get,
    ),
  );

  late final _inputInteractorDep = dep(
    () => InputInteractor(
      gameState: _gameStateDep.get,
      gameInteractor: _gameInteractorDep.get,
      inputState: _inputStateDep.get,
    ),
  );

  @override
  GameStateManager get gameState => _gameStateDep.get;

  @override
  TypingStateManager get typingState => _typingStateDep.get;

  @override
  EnemiesStateManager get enemiesState => _enemiesStateDep.get;

  @override
  TargetStateManager get targetState => _targetStateDep.get;

  @override
  PlayerStateManager get playerState => _playerStateDep.get;

  @override
  SettingsStateManager get settingsState => _settingsStateDep.get;

  @override
  GameInteractor get gameInteractor => _gameInteractorDep.get;

  @override
  SpawningInteractor get spawningInteractor => _spawningInteractorDep.get;

  @override
  GameLoopInteractor get gameLoopInteractor => _gameLoopInteractorDep.get;

  @override
  InputInteractor get inputInteractor => _inputInteractorDep.get;

  @override
  TypingInteractor get typingInteractor => _typingInteractorDep.get;

  @override
  LocalizationInteractor get localizationService =>
      _localizationInteractorDep.get;

  @override
  AudioService get audioService => _audioServiceDep.get;

  @override
  EnemiesCleanupInteractor get enemiesCleanupInteractor =>
      _enemiesCleanupInteractorDep.get;

  @override
  List<Set<AsyncDep>> get initializeQueue => [
    {_audioServiceDep, _settingsStorageDep},
    {
      _gameStateDep,
      _typingStateDep,
      _enemiesStateDep,
      _settingsStateDep,
      _localizationStateDep,
      _inputStateDep,
      _targetStateDep,
      _playerStateDep,
    },
    {
      _localizationInteractorDep,
      _playerInteractorDep,
      _targetInteractorDep,
      _typingInteractorDep,
      _enemiesCleanupInteractorDep,
    },
    {_gameInteractorDep},
    {_spawningInteractorDep},
  ];
}

/// Holder для управления жизненным циклом scope
class TupoScopeHolder extends ScopeHolder<TupoScopeContainer> {
  @override
  TupoScopeContainer createContainer() => TupoScopeContainer();
}
