import 'package:flutter/foundation.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/repositories/word_repository.dart';
import '../data/sources/audio_service.dart';
import '../data/sources/localization_service.dart';
import '../data/sources/soloud_audio_service.dart';
import '../data/sources/settings_storage.dart';
import '../data/sources/word_source.dart';
import '../domain/interactors/game_interactor.dart';
import '../domain/state_managers/game_state_manager.dart';
import '../domain/state_managers/settings_state_manager.dart';
import '../domain/state_managers/typing_state_manager.dart';
import '../presentation/game/tupo_game.dart';
import '../shared/models/game_config.dart';
import 'tupo_scope.dart';

/// Container для зависимостей игры Tupo
class TupoScopeContainer extends ScopeContainer implements TupoScope {
  // Shared
  final _config = const GameConfig();

  // Data layer - sources
  late final _audioServiceDep = asyncDep<AudioService>(() => kIsWeb 
      ? StubAudioService() 
      : SoloudAudioService());
  late final _wordSourceDep = dep(() => WordSource());
  late final _settingsStorageDep = asyncDep(() => SharedPreferencesSettingsStorage());
  late final _localizationServiceDep = asyncDep(() => LocalizationService(
        _settingsStateDep.get,
      ));

  // Data layer - repositories
  late final _wordRepositoryDep = dep(() => WordRepository(
        source: _wordSourceDep.get,
      ));

  // Domain layer - state managers
  late final _gameStateDep = asyncDep(() => GameStateManager(
        config: _config,
      ));

  late final _typingStateDep = asyncDep(() => TypingStateManager());

  late final _settingsStateDep = asyncDep(() => SettingsStateManager(
        _settingsStorageDep.get,
      ));

  // Domain layer - interactors
  late final _interactorDep = asyncDep(() => GameInteractor(
        gameState: _gameStateDep.get,
        typingState: _typingStateDep.get,
        wordRepository: _wordRepositoryDep.get,
        audioService: _audioServiceDep.get,
        config: _config,
        settingsState: _settingsStateDep.get,
      ));

  // Presentation layer
  late final _gameDep = asyncDep(() => TypoGame(
        gameState: _gameStateDep.get,
        typingState: _typingStateDep.get,
        interactor: _interactorDep.get,
      ));


  @override
  TypoGame get game => _gameDep.get;

  @override
  SettingsStateManager get settingsState => _settingsStateDep.get;

  @override
  AudioService get audioService => _audioServiceDep.get;

  @override
  LocalizationService get localizationService => _localizationServiceDep.get;

  @override
  List<Set<AsyncDep>> get initializeQueue => [
        {_audioServiceDep, _settingsStorageDep},
        {_gameStateDep, _typingStateDep, _settingsStateDep},
        {_localizationServiceDep},
        {_interactorDep},
        {_gameDep},
      ];
}

/// Holder для управления жизненным циклом scope
class TupoScopeHolder extends ScopeHolder<TupoScopeContainer> {
  @override
  TupoScopeContainer createContainer() => TupoScopeContainer();
}
