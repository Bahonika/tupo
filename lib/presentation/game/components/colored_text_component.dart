import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Компонент для отображения текста с разными цветами для разных частей
class ColoredTextComponent extends Component {
  final String fullText;
  int typedChars;
  final Color typedColor;
  Color remainingColor;
  TextStyle baseStyle;
  final Vector2 position;
  final Anchor anchor;

  ColoredTextComponent({
    required this.fullText,
    required this.typedChars,
    required this.typedColor,
    required this.remainingColor,
    required this.baseStyle,
    required this.position,
    this.anchor = Anchor.center,
  });

  @override
  void render(Canvas canvas) {
    if (fullText.isEmpty) return;

    final typedPart = typedChars > 0 && typedChars <= fullText.length
        ? fullText.substring(0, typedChars)
        : '';
    final remainingPart = typedChars < fullText.length
        ? fullText.substring(typedChars)
        : '';

    // Измеряем общую ширину текста для центрирования
    final fullTextPainter = TextPainter(
      text: TextSpan(
        text: fullText,
        style: baseStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    fullTextPainter.layout();

    final typedTextPaint = TextPaint(
      style: baseStyle.copyWith(color: typedColor),
    );
    final remainingTextPaint = TextPaint(
      style: baseStyle.copyWith(color: remainingColor),
    );

    // Вычисляем начальную позицию с учетом anchor
    double startX = position.x;
    final y = position.y;

    if (anchor == Anchor.bottomCenter || anchor == Anchor.center) {
      startX -= fullTextPainter.width / 2;
    } else if (anchor == Anchor.bottomRight || anchor == Anchor.centerRight) {
      startX -= fullTextPainter.width;
    }

    double currentX = startX;

    // Рисуем введенную часть (зеленым)
    if (typedPart.isNotEmpty) {
      // Используем TextPainter для измерения ширины
      final typedPainter = TextPainter(
        text: TextSpan(
          text: typedPart,
          style: baseStyle.copyWith(color: typedColor),
        ),
        textDirection: TextDirection.ltr,
      );
      typedPainter.layout();
      
      // Рисуем текст посимвольно для обработки пробелов
      for (int i = 0; i < typedPart.length; i++) {
        final char = typedPart[i];
        final charText = char;
        final charPainter = TextPainter(
          text: TextSpan(
            text: charText,
            style: baseStyle.copyWith(color: typedColor),
          ),
          textDirection: TextDirection.ltr,
        );
        charPainter.layout();
        
        typedTextPaint.render(
          canvas,
          charText,
          Vector2(currentX, y),
          anchor: Anchor.topLeft,
        );
        
        // Для пробелов рисуем зеленое подчеркивание
        if (char == ' ') {
          final fontSize = baseStyle.fontSize ?? 14;
          final underlinePaint = Paint()
            ..color = typedColor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;
          canvas.drawLine(
            Offset(currentX, y + fontSize * 1.2),
            Offset(currentX + charPainter.width, y + fontSize * 1.2),
            underlinePaint,
          );
        }
        
        currentX += charPainter.width;
      }
    }

    // Рисуем оставшуюся часть (обычным цветом)
    if (remainingPart.isNotEmpty) {
      // Рисуем текст посимвольно для обработки пробелов
      for (int i = 0; i < remainingPart.length; i++) {
        final char = remainingPart[i];
        final charText = char;
        final charPainter = TextPainter(
          text: TextSpan(
            text: charText,
            style: baseStyle.copyWith(color: remainingColor),
          ),
          textDirection: TextDirection.ltr,
        );
        charPainter.layout();
        
        remainingTextPaint.render(
          canvas,
          charText,
          Vector2(currentX, y),
          anchor: Anchor.topLeft,
        );
        
        // Для пробелов рисуем прозрачное/серое подчеркивание
        if (char == ' ') {
          final fontSize = baseStyle.fontSize ?? 14;
          final underlinePaint = Paint()
            ..color = remainingColor.withValues(alpha: 0.3)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;
          canvas.drawLine(
            Offset(currentX, y + fontSize * 1.2),
            Offset(currentX + charPainter.width, y + fontSize * 1.2),
            underlinePaint,
          );
        }
        
        currentX += charPainter.width;
      }
    }
  }
}
