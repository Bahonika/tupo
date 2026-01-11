import 'package:freezed_annotation/freezed_annotation.dart';

part 'enemy_data.freezed.dart';

/// Тип врага
enum EnemyType {
  /// Обычный враг
  normal,

  /// Специальный враг (для будущих механик)
  special,

  /// Волнистый враг (движется волнообразно по синусоиде)
  wavy,
}

/// Бизнес-модель врага
@freezed
sealed class EnemyData with _$EnemyData {
  const factory EnemyData({
    required String id,
    required String word,
    required double speed,
    required int damage,
    @Default(EnemyType.normal) EnemyType type,
  }) = _EnemyData;
}
