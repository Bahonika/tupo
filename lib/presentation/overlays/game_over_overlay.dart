import 'package:flutter/material.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../data/sources/localization_service.dart';
import '../../di/tupo_scope_container.dart';
import '../../domain/state/game_state.dart';
import '../game/tupo_game.dart';

class GameOverOverlay extends StatelessWidget {
  final TypoGame game;

  const GameOverOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<TupoScopeContainer>(
      builder: (context, scope) {
        if (scope == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final localization = scope.localizationService;

        return StateBuilder<GameState>(
          stateReadable: game.gameState,
          builder: (context, state, child) {
            final isWin = state.isWin;

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
                      color: isWin ? const Color(0xFFA8D5BA) : const Color(0xFFE8A8A8),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Иконка
                      Icon(
                        isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                        size: 80,
                        color: isWin ? const Color(0xFFD4A574) : const Color(0xFFE8A8A8),
                      ),
                      const SizedBox(height: 24),

                      // Заголовок
                      Text(
                        isWin
                            ? localization.translate(LocalizationKey.victory)
                            : localization.translate(LocalizationKey.gameOver),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isWin ? const Color(0xFF7FB89A) : const Color(0xFFD88A8A),
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Статистика
                      _StatRow(
                        icon: Icons.star,
                        label: localization.translate(LocalizationKey.score),
                        value: '${state.score}',
                        color: const Color(0xFFD4A574),
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.dangerous,
                        label: localization.translate(LocalizationKey.enemiesKilled),
                        value: '${state.enemiesKilled}',
                        color: const Color(0xFFE8A8A8),
                      ),
                      const SizedBox(height: 40),

                      // Кнопки
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: game.startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8D4D8),
                              foregroundColor: const Color(0xFF4A6B7A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              localization.translate(LocalizationKey.playAgain),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: game.returnToMenu,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6B8E9F),
                              side: const BorderSide(color: Color(0xFFB8D4D8)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              localization.translate(LocalizationKey.backToMenu),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color(0xFF6B8E9F),
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4A6B7A),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
