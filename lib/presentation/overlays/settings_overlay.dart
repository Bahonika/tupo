import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../domain/interactors/localization_interactor.dart';
import '../../di/tupo_scope_container.dart';
import '../../domain/state/settings_state.dart';
import '../../shared/models/settings.dart';
import '../game/tupo_game.dart';

class SettingsOverlay extends StatelessWidget {
  final TypoGame game;

  const SettingsOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<TupoScopeContainer>(
      builder: (context, scope) {
        if (scope == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final settingsState = scope.settingsState;
        final localization = scope.localizationService;

        return StateBuilder<SettingsState>(
          stateReadable: settingsState,
          builder: (context, state, child) {
            return Container(
              color: const Color(0xFFF5F5F5).withOpacity(0.95),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    margin: const EdgeInsets.all(40),
                    constraints: const BoxConstraints(maxWidth: 600),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFB8D4D8),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localization.translate(LocalizationKey.settingsTitle),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B8E9F),
                            letterSpacing: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Полноэкранный режим (только для Windows)
                        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows)
                          ...[_FullscreenSetting(
                            value: state.settings.fullscreen,
                            onChanged: (value) {
                              settingsState.setFullscreen(value);
                            },
                            localization: localization,
                          ),

                         const SizedBox(height: 24),
                        ],      
                        // Сложность
                        _DifficultySetting(
                          value: state.settings.difficulty,
                          onChanged: (value) {
                            settingsState.setDifficulty(value);
                          },
                          localization: localization,
                        ),

                        const SizedBox(height: 24),

                        // Язык
                        _LanguageSetting(
                          value: state.settings.language,
                          onChanged: (value) {
                            settingsState.setLanguage(value);
                          },
                          localization: localization,
                        ),

                        const SizedBox(height: 24),

                        // Громкость звуков
                        _VolumeSetting(
                          title: localization.translate(LocalizationKey.soundVolume),
                          value: state.settings.soundVolume,
                          onChanged: (value) {
                            settingsState.updateSoundVolume(value);
                          },
                          onChangeEnd: (value) {
                            settingsState.saveSoundVolume(value);
                          },
                        ),

                        const SizedBox(height: 24),

                        // Громкость музыки
                        _VolumeSetting(
                          title: localization.translate(LocalizationKey.musicVolume),
                          value: state.settings.musicVolume,
                          onChanged: (value) {
                            settingsState.updateMusicVolume(value);
                          },
                          onChangeEnd: (value) {
                            settingsState.saveMusicVolume(value);
                          },
                        ),

                        const SizedBox(height: 40),

                        // Кнопка закрытия
                        ElevatedButton(
                          onPressed: () {
                            game.overlays.remove('Settings');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8D4D8),
                            foregroundColor: const Color(0xFF4A6B7A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            localization.translate(LocalizationKey.close),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FullscreenSetting extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final LocalizationInteractor localization;

  const _FullscreenSetting({
    required this.value,
    required this.onChanged,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          localization.translate(LocalizationKey.fullscreen),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF6B8E9F),
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFB8D4D8),
        ),
      ],
    );
  }
}

class _DifficultySetting extends StatelessWidget {
  final Difficulty value;
  final ValueChanged<Difficulty> onChanged;
  final LocalizationInteractor localization;

  const _DifficultySetting({
    required this.value,
    required this.onChanged,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate(LocalizationKey.difficulty),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF6B8E9F),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<Difficulty>(
            segments: [
              ButtonSegment(
                value: Difficulty.easy,
                label: Text(localization.translate(LocalizationKey.easy)),
              ),
              ButtonSegment(
                value: Difficulty.medium,
                label: Text(localization.translate(LocalizationKey.medium)),
              ),
              ButtonSegment(
                value: Difficulty.hard,
                label: Text(localization.translate(LocalizationKey.hard)),
              ),
              ButtonSegment(
                value: Difficulty.extreme,
                label: Text(localization.translate(LocalizationKey.extreme)),
              ),
            ],
            selected: {value},
            onSelectionChanged: (Set<Difficulty> newSelection) {
              onChanged(newSelection.first);
            },
          ),
        ),
      ],
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  final Language value;
  final ValueChanged<Language> onChanged;
  final LocalizationInteractor localization;

  const _LanguageSetting({
    required this.value,
    required this.onChanged,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate(LocalizationKey.language),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF6B8E9F),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<Language>(
            segments: [
              ButtonSegment(
                value: Language.russian,
                label: Text(localization.translate(LocalizationKey.russian)),
              ),
              ButtonSegment(
                value: Language.english,
                label: Text(localization.translate(LocalizationKey.english)),
              ),
            ],
            selected: {value},
            onSelectionChanged: (Set<Language> newSelection) {
              onChanged(newSelection.first);
            },
          ),
        ),
      ],
    );
  }
}

class _VolumeSetting extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  const _VolumeSetting({
    required this.title,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF6B8E9F),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF8FA8B2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: value,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          activeColor: const Color(0xFFB8D4D8),
          inactiveColor: const Color(0xFFE8F0F2),
        ),
      ],
    );
  }
}
