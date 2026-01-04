import 'package:flutter/material.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../data/sources/localization_service.dart';
import '../../di/tupo_scope_container.dart';
import '../game/tupo_game.dart';

class MainMenu extends StatelessWidget {
  final TypoGame game;

  const MainMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<TupoScopeContainer>(
      builder: (context, scope) {
        if (scope == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final localization = scope.localizationService;

        return Container(
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Название игры
                Text(
                  localization.translate(LocalizationKey.gameTitle),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B8E9F),
                    letterSpacing: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localization.translate(LocalizationKey.gameSubtitle),
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF6B8E9F).withOpacity(0.7),
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 60),

                // Кнопка старта
                ElevatedButton(
                  onPressed: game.startGame,
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
                    localization.translate(LocalizationKey.startGame),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    game.overlays.add('Settings');
                  },
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
                    localization.translate(LocalizationKey.settings),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Инструкции
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        localization.translate(LocalizationKey.howToPlay),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B8E9F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InstructionRow(
                        icon: Icons.mouse,
                        text: localization.translate(LocalizationKey.hoverEnemy),
                      ),
                      const SizedBox(height: 8),
                      _InstructionRow(
                        icon: Icons.keyboard,
                        text: localization.translate(LocalizationKey.typeWord),
                      ),
                      const SizedBox(height: 8),
                      _InstructionRow(
                        icon: Icons.warning,
                        text: localization.translate(LocalizationKey.dontLetReach),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InstructionRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF8FA8B2), size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6B8E9F),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
