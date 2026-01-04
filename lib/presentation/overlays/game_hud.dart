import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../domain/state/game_state.dart';
import '../../domain/state/typing_state.dart';
import '../game/tupo_game.dart';

/// CustomPainter для отрисовки текста с визуализацией пробелов
class _TypingTextPainter extends CustomPainter {
  final String typedPart;
  final String remainingPart;
  final Color typedColor;
  final Color remainingColor;
  final double fontSize;
  final double letterSpacing;

  _TypingTextPainter({
    required this.typedPart,
    required this.remainingPart,
    required this.typedColor,
    required this.remainingColor,
    required this.fontSize,
    required this.letterSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: letterSpacing,
    );

    double currentX = 0;
    // Центрируем по вертикали, оставляя место для подчеркивания
    final y = (size.height - fontSize) / 2;

    // Рисуем набранную часть
    for (int i = 0; i < typedPart.length; i++) {
      final char = typedPart[i];
      final charText = char.toUpperCase();
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: charText,
          style: textStyle.copyWith(color: typedColor),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      textPainter.paint(canvas, Offset(currentX, y - textPainter.height / 2));
      
      // Для пробелов рисуем зеленое подчеркивание
      if (char == ' ') {
        final underlinePaint = Paint()
          ..color = typedColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(currentX, y + fontSize * 0.6),
          Offset(currentX + textPainter.width, y + fontSize * 0.6),
          underlinePaint,
        );
      }
      
      currentX += textPainter.width;
    }

    // Рисуем оставшуюся часть
    for (int i = 0; i < remainingPart.length; i++) {
      final char = remainingPart[i];
      final charText = char.toUpperCase();
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: charText,
          style: textStyle.copyWith(color: remainingColor),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      textPainter.paint(canvas, Offset(currentX, y - textPainter.height / 2));
      
      // Для пробелов рисуем прозрачное/серое подчеркивание
      if (char == ' ') {
        final underlinePaint = Paint()
          ..color = remainingColor.withValues(alpha: 0.3)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(currentX, y + fontSize * 0.6),
          Offset(currentX + textPainter.width, y + fontSize * 0.6),
          underlinePaint,
        );
      }
      
      currentX += textPainter.width;
    }
  }

  @override
  bool shouldRepaint(_TypingTextPainter oldDelegate) {
    return oldDelegate.typedPart != typedPart ||
        oldDelegate.remainingPart != remainingPart ||
        oldDelegate.typedColor != typedColor ||
        oldDelegate.remainingColor != remainingColor;
  }
}

class GameHud extends StatelessWidget {
  final TypoGame game;

  const GameHud({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(game: game),
            const Spacer(),
            _TypingIndicator(game: game),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final TypoGame game;

  const _TopBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return StateBuilder<GameState>(
      stateReadable: game.gameState,
      builder: (context, state, child) {
        return Row(
          children: [
            Expanded(
              child: _HealthBar(state: state),
            ),
            const SizedBox(width: 24),
            _ScoreDisplay(state: state),
            const SizedBox(width: 24),
            _KillCount(state: state),
          ],
        );
      },
    );
  }
}

class _HealthBar extends StatelessWidget {
  final GameState state;

  const _HealthBar({required this.state});

  static Color _getHealthColor(double percent) {
    if (percent > 0.6) return const Color(0xFFA8D5BA);
    if (percent > 0.3) return const Color(0xFFE8C8A8);
    return const Color(0xFFE8A8A8);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, color: Color(0xFFE8A8A8), size: 20),
            const SizedBox(width: 8),
            Text(
              '${state.health}/${state.maxHealth}',
              style: const TextStyle(
                color: Color(0xFF4A6B7A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFE0E0E0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: state.healthPercent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _getHealthColor(state.healthPercent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final GameState state;

  const _ScoreDisplay({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFD4A574), size: 20),
          const SizedBox(width: 8),
          Text(
            '${state.score}',
            style: const TextStyle(
              color: Color(0xFF4A6B7A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _KillCount extends StatelessWidget {
  final GameState state;

  const _KillCount({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.dangerous, color: Color(0xFFE8A8A8), size: 20),
          const SizedBox(width: 8),
          Text(
            '${state.enemiesKilled}/50',
            style: const TextStyle(
              color: Color(0xFF4A6B7A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final TypoGame game;

  const _TypingIndicator({required this.game});

  @override
  Widget build(BuildContext context) {
    return StateBuilder<TypingState>(
      stateReadable: game.typingState,
      builder: (context, state, child) {
        if (!state.hasTarget) {
          return const SizedBox.shrink();
        }

        return _TypingWordWidget(
          state: state,
          onErrorShown: () {
            game.typingState.clearError();
          },
        );
      },
    );
  }
}

class _TypingWordWidget extends StatefulWidget {
  final TypingState state;
  final VoidCallback onErrorShown;

  const _TypingWordWidget({
    required this.state,
    required this.onErrorShown,
  });

  @override
  State<_TypingWordWidget> createState() => _TypingWordWidgetState();
}

class _TypingWordWidgetState extends State<_TypingWordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _errorAnimationController;
  late Animation<double> _errorAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _errorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _errorAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(_TypingWordWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если появилась ошибка и анимация не запущена, запускаем мигание
    if (widget.state.lastError && 
        !oldWidget.state.lastError && 
        !_isAnimating) {
      _isAnimating = true;
      // Сначала показываем красный цвет
      _errorAnimationController.forward().then((_) {
        // Держим красный цвет немного
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            // Возвращаем обратно к обычному цвету
            _errorAnimationController.reverse().then((_) {
              if (mounted) {
                _isAnimating = false;
                widget.onErrorShown();
              }
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _errorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Слово с подсветкой набранной части и анимацией ошибки
          AnimatedBuilder(
            animation: _errorAnimation,
            builder: (context, child) {
              // Цвет слова при ошибке (красный) или обычный
              final wordColor = Color.lerp(
                const Color(0xFF8FA8B2), // Обычный цвет
                const Color(0xFFE8A8A8), // Красный при ошибке
                _errorAnimation.value,
              )!;

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Измеряем размер текста
                  final textStyle = TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  );
                  
                  final fullText = (widget.state.typedPart + widget.state.remainingPart).toUpperCase();
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: fullText,
                      style: textStyle,
                    ),
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                  );
                  textPainter.layout(maxWidth: constraints.maxWidth);
                  
                  return SizedBox(
                    width: textPainter.width,
                    height: textPainter.height + 10, // Дополнительное место для подчеркивания
                    child: CustomPaint(
                      painter: _TypingTextPainter(
                        typedPart: widget.state.typedPart,
                        remainingPart: widget.state.remainingPart,
                        typedColor: Color.lerp(
                          const Color(0xFF7FB89A), // Зеленый
                          const Color(0xFFE8A8A8), // Красный при ошибке
                          _errorAnimation.value,
                        )!,
                        remainingColor: wordColor,
                        fontSize: 32,
                        letterSpacing: 4,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
