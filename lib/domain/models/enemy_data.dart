/// Тип врага
enum EnemyType {
  /// Обычный враг
  normal,

  /// Быстрый враг (меньше урона, выше скорость)
  fast,

  /// Танк (больше урона, ниже скорость, длинное слово)
  tank,

  /// Специальный враг (для будущих механик)
  special,

  /// Волнистый враг (движется волнообразно по синусоиде)
  wavy,
}

/// Бизнес-модель врага
class EnemyData {
  final String id;
  final String word;
  final double speed;
  final int damage;
  final EnemyType type;

  const EnemyData({
    required this.id,
    required this.word,
    required this.speed,
    required this.damage,
    this.type = EnemyType.normal,
  });

  /// Длина слова
  int get wordLength => word.length;

  EnemyData copyWith({
    String? id,
    String? word,
    double? speed,
    int? damage,
    EnemyType? type,
  }) {
    return EnemyData(
      id: id ?? this.id,
      word: word ?? this.word,
      speed: speed ?? this.speed,
      damage: damage ?? this.damage,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnemyData &&
        other.id == id &&
        other.word == word &&
        other.speed == speed &&
        other.damage == damage &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, word, speed, damage, type);

  @override
  String toString() =>
      'EnemyData(id: $id, word: $word, speed: $speed, damage: $damage, type: $type)';
}
