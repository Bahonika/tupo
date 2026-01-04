import 'dart:async';

import 'package:async/async.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yx_state/yx_state.dart';

import '../../data/sources/settings_storage.dart';
import '../../shared/models/settings.dart';
import '../state/settings_state.dart';

/// StateManager для управления настройками игры
class SettingsStateManager extends StateManager<SettingsState>
    implements AsyncLifecycle {
  final SettingsStorage _storage;
  
  // Операция сохранения для отмены предыдущих
  CancelableOperation<void>? _saveOperation;

  SettingsStateManager(this._storage)
    : super(const SettingsState(settings: Settings()));

  @override
  Future<void> init() async {
    await loadSettings();
  }

  @override
  Future<void> dispose() async {
    await _saveOperation?.cancel();
    await close();
  }

  /// Загрузить настройки из хранилища
  Future<void> loadSettings() => handle((emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _storage.loadSettings();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (error) {
      addError(error);
      emit(state.copyWith(isLoading: false));
    }
  });

  /// Сохранить настройки в хранилище (без изменения state)
  Future<void> _saveSettings(Settings settings) async {
    try {
      await _storage.saveSettings(settings);
    } catch (error) {
      addError(error);
      rethrow;
    }
  }

  /// Обновить полноэкранный режим
  Future<void> setFullscreen(bool fullscreen) => handle((emit) async {
    final newSettings = state.settings.copyWith(fullscreen: fullscreen);
    emit(state.copyWith(isSaving: true));
    try {
      await _saveSettings(newSettings);
      emit(state.copyWith(settings: newSettings, isSaving: false));
    } catch (error) {
      emit(state.copyWith(isSaving: false));
    }
  });

  /// Обновить сложность
  Future<void> setDifficulty(Difficulty difficulty) => handle((emit) async {
    final newSettings = state.settings.copyWith(difficulty: difficulty);
    emit(state.copyWith(isSaving: true));
    try {
      await _saveSettings(newSettings);
      emit(state.copyWith(settings: newSettings, isSaving: false));
    } catch (error) {
      emit(state.copyWith(isSaving: false));
    }
  });

  /// Обновить язык
  Future<void> setLanguage(Language language) => handle((emit) async {
    final newSettings = state.settings.copyWith(language: language);
    emit(state.copyWith(isSaving: true));
    try {
      await _saveSettings(newSettings);
      emit(state.copyWith(settings: newSettings, isSaving: false));
    } catch (error) {
      emit(state.copyWith(isSaving: false));
    }
  });

  /// Обновить громкость звуков (только state, без сохранения)
  void updateSoundVolume(double volume) => handle((emit) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    final newSettings = state.settings.copyWith(soundVolume: clampedVolume);
    emit(state.copyWith(settings: newSettings));
  });

  /// Сохранить громкость звуков в storage (с отменой предыдущих операций)
  Future<void> saveSoundVolume(double volume) {
    // Отменяем предыдущую операцию сохранения
    _saveOperation?.cancel();
    
    final clampedVolume = volume.clamp(0.0, 1.0);
    final newSettings = state.settings.copyWith(soundVolume: clampedVolume);
    
    // Создаем новую операцию сохранения
    final completer = CancelableCompleter<void>();
    _saveOperation = completer.operation;
    
    handle((emit) async {
      emit(state.copyWith(isSaving: true));
      try {
        await _saveSettings(newSettings);
        if (!completer.isCanceled) {
          emit(state.copyWith(settings: newSettings, isSaving: false));
          completer.complete();
        }
      } catch (error) {
        if (!completer.isCanceled) {
          emit(state.copyWith(isSaving: false));
          completer.completeError(error);
        }
      }
    });
    
    return completer.operation.valueOrCancellation();
  }

  /// Обновить громкость музыки (только state, без сохранения)
  void updateMusicVolume(double volume) => handle((emit) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    final newSettings = state.settings.copyWith(musicVolume: clampedVolume);
    emit(state.copyWith(settings: newSettings));
  });

  /// Сохранить громкость музыки в storage (с отменой предыдущих операций)
  Future<void> saveMusicVolume(double volume) {
    // Отменяем предыдущую операцию сохранения
    _saveOperation?.cancel();
    
    final clampedVolume = volume.clamp(0.0, 1.0);
    final newSettings = state.settings.copyWith(musicVolume: clampedVolume);
    
    // Создаем новую операцию сохранения
    final completer = CancelableCompleter<void>();
    _saveOperation = completer.operation;
    
    handle((emit) async {
      emit(state.copyWith(isSaving: true));
      try {
        await _saveSettings(newSettings);
        if (!completer.isCanceled) {
          emit(state.copyWith(settings: newSettings, isSaving: false));
          completer.complete();
        }
      } catch (error) {
        if (!completer.isCanceled) {
          emit(state.copyWith(isSaving: false));
          completer.completeError(error);
        }
      }
    });
    
    return completer.operation.valueOrCancellation();
  }
}
