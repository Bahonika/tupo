import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import 'di/tupo_scope_container.dart';
import 'domain/state/settings_state.dart';
import 'presentation/game/tupo_game.dart';
import 'presentation/overlays/game_hud.dart';
import 'presentation/overlays/game_over_overlay.dart';
import 'presentation/overlays/main_menu.dart';
import 'presentation/overlays/pause_menu.dart';
import 'presentation/overlays/settings_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация window_manager для Windows (только для десктопа)
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    await windowManager.ensureInitialized();
  }

  final scopeHolder = TupoScopeHolder();
  await scopeHolder.create();

  runApp(TypoApp(scopeHolder: scopeHolder));
}

class TypoApp extends StatelessWidget {
  final TupoScopeHolder scopeHolder;

  const TypoApp({required this.scopeHolder, super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeProvider<TupoScopeContainer>(
      holder: scopeHolder,
      child: MaterialApp(
        title: 'Tupo - Typing Shooter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<TupoScopeContainer>.withPlaceholder(
      placeholder: const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFFB8D4D8)),
              SizedBox(height: 16),
              Text(
                'Загрузка...',
                style: TextStyle(color: Color(0xFF6B8E9F)),
              ),
            ],
          ),
        ),
      ),
      builder: (context, scope) {
        // Применяем настройку полноэкранного режима при первой загрузке
        // Запускаем фоновую музыку при старте приложения
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _applyFullscreen(scope.settingsState.state.settings.fullscreen);
          _initAudio(scope);
        });

        return StateListener<SettingsState>(
          stateReadable: scope.settingsState,
          listenWhen: (previous, current) =>
              previous.settings.fullscreen != current.settings.fullscreen ||
              previous.settings.musicVolume != current.settings.musicVolume ||
              previous.settings.soundVolume != current.settings.soundVolume,
          listener: (context, state) {
            _applyFullscreen(state.settings.fullscreen);
            scope.audioService.setSoundVolume(state.settings.soundVolume);
            scope.audioService.setMusicVolume(state.settings.musicVolume);
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: GameWidget<TypoGame>(
              game: scope.game,
              overlayBuilderMap: {
                'MainMenu': (context, game) => MainMenu(game: game),
                'HUD': (context, game) => GameHud(game: game),
                'GameOver': (context, game) => GameOverOverlay(game: game),
                'PauseMenu': (context, game) => PauseMenu(game: game),
                'Settings': (context, game) => SettingsOverlay(game: game),
              },
            ),
          ),
        );
      },
    );
  }

  static Future<void> _applyFullscreen(bool fullscreen) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      await windowManager.setFullScreen(fullscreen);
    }
  }

  static void _initAudio(TupoScopeContainer scope) {
    final audioService = scope.audioService;
    final settings = scope.settingsState.state.settings;
    
    // Устанавливаем громкость из настроек
    audioService.setSoundVolume(settings.soundVolume);
    audioService.setMusicVolume(settings.musicVolume);
    
    // Запускаем фоновую музыку
    audioService.playBackgroundMusic();
  }
}
