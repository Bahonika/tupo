import 'package:flutter/material.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../data/sources/localization_service.dart';
import '../../di/tupo_scope_container.dart';
import '../game/tupo_game.dart';

class PauseMenu extends StatelessWidget {
  final TypoGame game;

  const PauseMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<TupoScopeContainer>(
      builder: (context, scope) {
        if (scope == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final localization = scope.localizationService;

        return Container(
          color: const Color(0xFFF5F5F5).withOpacity(0.95),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              margin: const EdgeInsets.all(40),
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
                children: [
                  // Иконка паузы
                  const Icon(
                    Icons.pause_circle_outline,
                    size: 80,
                    color: Color(0xFF6B8E9F),
                  ),
                  const SizedBox(height: 24),

                  // Заголовок
                  Text(
                    localization.translate(LocalizationKey.pause),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B8E9F),
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Кнопки
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('PauseMenu');
                      game.interactor.resumeGame();
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
                      localization.translate(LocalizationKey.resume),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: game.returnToMenu,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B8E9F),
                      side: const BorderSide(color: Color(0xFFB8D4D8)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      localization.translate(LocalizationKey.backToMenu),
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
        );
      },
    );
  }
}
