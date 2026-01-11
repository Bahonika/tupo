# Нарушения архитектуры

## DI слой

### 1. Создание Presentation-компонента в DI-контейнере

**Файл:** `lib/di/tupo_scope_container.dart`

**Нарушение:** `TupoScopeContainer` создаёт `TypoGame` (FlameGame) внутри DI-контейнера.

**Правило:** flame-clean-architecture (3.1) — "Создание Component внутри DI контейнера запрещено".

**Исправление:** Создавать `TypoGame` в Presentation-слое (например, в `main.dart` или в отдельном builder-классе), передавая зависимости из Scope.

```dart
// Вместо создания в DI:
late final _gameDep = asyncDep(() => TypoGame(...));

// Создавать в Presentation:
final game = TypoGame(
  gameState: scope.gameState,
  typingState: scope.typingState,
  // ...
);
```

---

### 2. Scope экспортирует Presentation-компонент

**Файл:** `lib/di/tupo_scope.dart`

**Нарушение:** `TupoScope.game` возвращает `TypoGame`.

**Правило:** Scope должен предоставлять зависимости Domain и Data слоёв, но не Presentation-компоненты.

**Исправление:** Убрать `game` из интерфейса `TupoScope`. Presentation-компоненты создаются и управляются в Presentation-слое.

---

## Domain слой

### 3. Function как зависимость в GameInteractor

**Файл:** `lib/domain/interactors/game_interactor.dart`

**Нарушение:** Поле `void Function(String enemyId)? onEnemyKilled` — это Function как зависимость.

**Правило:** no-function-dependency — "You can not put Function in any dependency."

**Исправление:** Использовать реактивный подход через состояние. Вместо callback создать событие в состоянии, на которое Presentation подписывается:

```dart
// В EnemiesState добавить:
final String? lastKilledEnemyId;

// Presentation подписывается через StateListenerComponent
```

---

### 4. StateManager зависит от StateManager

**Файл:** `lib/domain/state_managers/localization_state_manager.dart`

**Нарушение:** `LocalizationStateManager` принимает `SettingsStateManager` в конструкторе.

**Правило:** flutter-clean-architecture (2.2.2.9) — "StateManager не может зависеть от StateManager".

**Исправление:** Вынести логику синхронизации языка в `LocalizationInteractor`, который будет зависеть от обоих StateManager:

```dart
class LocalizationInteractor {
  final LocalizationStateManager _localizationState;
  final SettingsStateManager _settingsState;
  
  // Interactor подписывается на _settingsState и обновляет _localizationState
}
```

---

### 5. Данные переводов в Interactor

**Файл:** `lib/domain/interactors/localization_interactor.dart`

**Нарушение:** `LocalizationInteractor` содержит статические карты переводов (`_russianTranslations`, `_englishTranslations`).

**Правило:** flutter-clean-architecture (2.1.1) — Data-слой отвечает за read/write доступ к данным.

**Исправление:** Вынести переводы в `LocalizationSource` (Data-слой):

```dart
// lib/data/sources/localization_source.dart
class LocalizationSource {
  String translate(LocalizationKey key, Language language) { ... }
}
```

---

## Presentation слой

### 6. Использование HasGameReference

**Файл:** `lib/presentation/game/components/player_component.dart`

**Нарушение:** `PlayerComponent` использует `HasGameReference<TypoGame>` для доступа к `game.gameState`.

**Правило:** flame-clean-architecture (3.1) — "Использование HasGameReference для получения зависимостей из game instance запрещено".

**Исправление:** Передавать `StateReadable<GameState>` через конструктор:

```dart
class PlayerComponent extends PositionComponent {
  final StateReadable<GameState> gameState;
  
  PlayerComponent({
    required this.gameState,
    required Vector2 position,
  });
}
```

---

### 7. Function как зависимость в EnemyComponent (onReachTarget)

**Файл:** `lib/presentation/game/components/enemy_component.dart`

**Нарушение:** `VoidCallback onReachTarget` — Function как зависимость.

**Правило:** no-function-dependency.

**Исправление:** Передавать `Interactor` и вызывать его метод:

```dart
class EnemyComponent extends PositionComponent {
  final GameInteractor interactor;
  final EnemyData data;
  
  // Вместо onReachTarget() вызывать:
  // interactor.onEnemyCollision(data.id, data.damage);
}
```

---

### 8. Function как зависимость в EnemyComponent (getTypingState)

**Файл:** `lib/presentation/game/components/enemy_component.dart`

**Нарушение:** `TypingState? Function()? getTypingState` — Function как зависимость.

**Правило:** no-function-dependency.

**Исправление:** Передавать `StateReadable<TypingState>` через конструктор:

```dart
class EnemyComponent extends PositionComponent {
  final StateReadable<TypingState> typingState;
  
  // В update():
  final state = typingState.state;
}
```

---

### 9. Бизнес-логика в TypoGame

**Файл:** `lib/presentation/game/tupo_game.dart`

**Нарушение:** Методы `_updateAiming()`, `_updateTargetHighlight()` содержат бизнес-логику (вычисление углов, поиск ближайшего врага, условия выделения).

**Правило:** flame-clean-architecture (1.5, 3.1) — "Недопустима любая бизнес-логика внутри Component, включая проверки типов и условия".

**Исправление:** Вынести логику прицеливания в `AimingInteractor`:

```dart
class AimingInteractor {
  void updateAim(double mouseX, double mouseY, List<EnemyPosition> enemies);
  // Результат — изменение состояния (targetEnemyId)
}
```

---

### 10. StreamSubscription в build() без dispose

**Файл:** `lib/presentation/overlays/settings_overlay.dart`

**Нарушение:** `_settingsSubscription` создаётся в методе `build()` через `ScopeBuilder`, но `cancel()` вызывается только в `dispose()` State. При пересборке виджета создаются новые подписки без отмены предыдущих.

**Правило:** Утечка памяти и некорректное управление ресурсами.

**Исправление:** Использовать `StateListener` из yx_state_flutter:

```dart
StateListener<SettingsState>(
  stateReadable: settingsState,
  listener: (context, state) {
    audioService.setSoundVolume(state.settings.soundVolume);
    audioService.setMusicVolume(state.settings.musicVolume);
  },
  child: // ...
)
```

---

## Сводка

| # | Слой | Файл | Нарушение | Правило |
|---|------|------|-----------|---------|
| 1 | DI | tupo_scope_container.dart | Создание TypoGame в DI | flame 3.1 |
| 2 | DI | tupo_scope.dart | Экспорт TypoGame | — |
| 3 | Domain | game_interactor.dart | Function onEnemyKilled | no-function-dependency |
| 4 | Domain | localization_state_manager.dart | SM зависит от SM | flutter 2.2.2.9 |
| 5 | Domain | localization_interactor.dart | Данные в Interactor | flutter 2.1.1 |
| 6 | Presentation | player_component.dart | HasGameReference | flame 3.1 |
| 7 | Presentation | enemy_component.dart | Function onReachTarget | no-function-dependency |
| 8 | Presentation | enemy_component.dart | Function getTypingState | no-function-dependency |
| 9 | Presentation | tupo_game.dart | Бизнес-логика в Component | flame 1.5, 3.1 |
| 10 | Presentation | settings_overlay.dart | StreamSubscription в build | — |
