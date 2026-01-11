import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColoredTextComponent extends Component {
  final String fullText;
  final Color typedColor;
  final Vector2 position;
  final Anchor anchor;

  int _typedChars;
  int get typedChars => _typedChars;
  set typedChars(int value) {
    if (_typedChars != value) {
      _typedChars = value;
      _invalidateCache();
    }
  }

  Color _remainingColor;
  Color get remainingColor => _remainingColor;
  set remainingColor(Color value) {
    if (_remainingColor != value) {
      _remainingColor = value;
      _invalidateCache();
    }
  }

  TextStyle _baseStyle;
  TextStyle get baseStyle => _baseStyle;
  set baseStyle(TextStyle value) {
    if (_baseStyle != value) {
      _baseStyle = value;
      _invalidateCharWidths();
      _invalidateCache();
    }
  }

  ColoredTextComponent({
    required this.fullText,
    required int typedChars,
    required this.typedColor,
    required Color remainingColor,
    required TextStyle baseStyle,
    required this.position,
    this.anchor = Anchor.center,
  })  : _typedChars = typedChars,
        _remainingColor = remainingColor,
        _baseStyle = baseStyle;

  // Кэшированные данные
  late List<double> _charWidths;
  late double _totalWidth;
  bool _charWidthsValid = false;

  TextPainter? _typedPainter;
  TextPainter? _remainingPainter;
  bool _cacheValid = false;
  int _cachedTypedChars = -1;

  late final Paint _typedUnderlinePaint = Paint()
    ..color = typedColor
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  Paint? _remainingUnderlinePaint;

  void _ensureCharWidths() {
    if (_charWidthsValid) return;

    _charWidths = List<double>.filled(fullText.length, 0);
    _totalWidth = 0;

    final painter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < fullText.length; i++) {
      painter.text = TextSpan(text: fullText[i], style: _baseStyle);
      painter.layout();
      _charWidths[i] = painter.width;
      _totalWidth += painter.width;
    }

    _charWidthsValid = true;
  }

  void _invalidateCharWidths() {
    _charWidthsValid = false;
  }

  void _invalidateCache() {
    _cacheValid = false;
  }

  void _rebuildPainters() {
    if (_cacheValid && _cachedTypedChars == _typedChars) return;

    _ensureCharWidths();

    final typedPart = _typedChars > 0 && _typedChars <= fullText.length
        ? fullText.substring(0, _typedChars)
        : '';
    final remainingPart = _typedChars < fullText.length
        ? fullText.substring(_typedChars)
        : '';

    if (typedPart.isNotEmpty) {
      _typedPainter = TextPainter(
        text: TextSpan(
          text: typedPart,
          style: _baseStyle.copyWith(color: typedColor),
        ),
        textDirection: TextDirection.ltr,
      );
      _typedPainter!.layout();
    } else {
      _typedPainter = null;
    }

    if (remainingPart.isNotEmpty) {
      _remainingPainter = TextPainter(
        text: TextSpan(
          text: remainingPart,
          style: _baseStyle.copyWith(color: _remainingColor),
        ),
        textDirection: TextDirection.ltr,
      );
      _remainingPainter!.layout();
    } else {
      _remainingPainter = null;
    }

    _remainingUnderlinePaint = Paint()
      ..color = _remainingColor.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _cacheValid = true;
    _cachedTypedChars = _typedChars;
  }

  @override
  void render(Canvas canvas) {
    if (fullText.isEmpty) return;

    _rebuildPainters();

    double startX = position.x;
    final y = position.y;

    if (anchor == Anchor.bottomCenter || anchor == Anchor.center) {
      startX -= _totalWidth / 2;
    } else if (anchor == Anchor.bottomRight || anchor == Anchor.centerRight) {
      startX -= _totalWidth;
    }

    double currentX = startX;

    if (_typedPainter != null) {
      _typedPainter!.paint(canvas, Offset(currentX, y));

      // Подчёркивания для пробелов в typed части
      final fontSize = _baseStyle.fontSize ?? 14;
      final underlineY = y + fontSize * 1.2;
      double charX = currentX;

      for (int i = 0; i < _typedChars && i < fullText.length; i++) {
        if (fullText[i] == ' ') {
          canvas.drawLine(
            Offset(charX, underlineY),
            Offset(charX + _charWidths[i], underlineY),
            _typedUnderlinePaint,
          );
        }
        charX += _charWidths[i];
      }

      currentX += _typedPainter!.width;
    }

    if (_remainingPainter != null) {
      _remainingPainter!.paint(canvas, Offset(currentX, y));

      // Подчёркивания для пробелов в remaining части
      final fontSize = _baseStyle.fontSize ?? 14;
      final underlineY = y + fontSize * 1.2;
      double charX = currentX;

      for (int i = _typedChars; i < fullText.length; i++) {
        if (fullText[i] == ' ') {
          canvas.drawLine(
            Offset(charX, underlineY),
            Offset(charX + _charWidths[i], underlineY),
            _remainingUnderlinePaint!,
          );
        }
        charX += _charWidths[i];
      }
    }
  }
}
