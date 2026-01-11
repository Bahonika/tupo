import '../data/sources/audio_service.dart';
import '../domain/interactors/enemies_cleanup_interactor.dart';
import '../domain/interactors/game_interactor.dart';
import '../domain/interactors/game_loop_interactor.dart';
import '../domain/interactors/input_interactor.dart';
import '../domain/interactors/localization_interactor.dart';
import '../domain/interactors/spawning_interactor.dart';
import '../domain/interactors/typing_interactor.dart';
import '../domain/state_managers/enemies_state_manager.dart';
import '../domain/state_managers/game_state_manager.dart';
import '../domain/state_managers/player_state_manager.dart';
import '../domain/state_managers/settings_state_manager.dart';
import '../domain/state_managers/target_state_manager.dart';
import '../domain/state_managers/typing_state_manager.dart';

/// Интерфейс scope для игры Tupo
abstract interface class TupoScope {
  GameStateManager get gameState;
  TypingStateManager get typingState;
  EnemiesStateManager get enemiesState;
  TargetStateManager get targetState;
  PlayerStateManager get playerState;
  SettingsStateManager get settingsState;
  GameInteractor get gameInteractor;
  SpawningInteractor get spawningInteractor;
  GameLoopInteractor get gameLoopInteractor;
  InputInteractor get inputInteractor;
  TypingInteractor get typingInteractor;
  LocalizationInteractor get localizationService;
  AudioService get audioService;
  EnemiesCleanupInteractor get enemiesCleanupInteractor;
}
