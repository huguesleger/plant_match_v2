# Règles de Développement - Projet PlantMatch V2

## Programmation Fonctionnelle (fpdart)

### Pattern de gestion des états dans les Cubits

Toujours utiliser le pattern suivant pour les appels asynchrones retournant un `TaskEither` :

```dart
// ✅ DO
someRepo
  .loadSomething()
  .match(
    (failure) => ErrorState(failure.message),
    (success) => SuccessState(success),
  )
  .map(emit)
  .run();

// ❌ DON'T
someRepo
  .loadSomething()
  .match(
    (failure) => emit(ErrorState(failure.message)),
    (success) => emit(SuccessState(success)),
  )
  .run();
```

### Principes
- Préférer `Either` à `TaskEither` quand l'opération est synchrone.
- Éviter les effets de bord (comme `emit`) à l'intérieur des transformations (`map`, `flatMap`, `match`).
- Utiliser la composition fonctionnelle pour chaîner les opérations.
- Utiliser `Unit` (de `fpdart`) au lieu de `void` pour les retours de `TaskEither`.
