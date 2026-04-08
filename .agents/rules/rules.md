---
trigger: always_on
---

# Règles de Développement - Projet PlantMatch V2

## Architecture Propre
- Chaque fonctionnalité est implémentée dans `/lib/features/nom_feature`.
- Séparer les couches `data`, `domain` et `presentation` dans des sous-répertoires.
- Le répertoire `data` contient les sources de données, mappers et l'implémentation des repositories.
- Le répertoire `domain` contient les entités du domaine et la définition des repositories (les `use_cases` ne sont nécessaires que si spécifiés).
- Le répertoire `presentation` contient les widgets Flutter et la logique de présentation.

## Couche Présentation
- Utiliser Flutter Bloc `Cubit` pour la gestion d'état et la logique de présentation.
- Diviser une page en plusieurs widgets :
    - Une route pour la feature nommée `<feature>_page_route.dart`.
    - Un écran principal définissant le layout nommé `<feature>_screen.dart`.
    - Le widget de l'écran doit uniquement définir la structure globale et déléguer le reste (header, content, footer, etc.) à d'autres widgets spécialisés.
    - Les widgets sémantiques ne doivent pas dépasser 100 lignes de code.
- Utiliser `BlocBuilder` pour construire l'écran en fonction de l'état du Cubit.

## Programmation Fonctionnelle (fpdart)
- Utiliser `fpdart` pour la programmation fonctionnelle.
- **Jamais de null** : préférer `Option<T>`.
- Utiliser `Either` pour la gestion d'erreurs, et particulièrement `TaskEither` pour les opérations asynchrones.
- Toujours composer les opérations de manière simple et propre.
- Les Cubits sont responsables de l'exécution (`run()`) à la fin de la chaîne.

### Pattern de gestion des états dans les Cubits

Toujours utiliser le pattern suivant pour les appels asynchrones :

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

### Autres Principes
- Utiliser des objets **immuables** pour les états.
- Utiliser  `Cubit` 
- Utiliser des **Sum Types** au lieu de Product Types : privilégier les `sealed classes` aux enums.
- Jamais de `default` case dans les `switch` sur des `sealed classes` pour garantir l'exhaustivité.
- Préférer les **expressions** aux statements (blocs de code).
- Utiliser les ternaires au lieu de `if-else`.
- Utiliser `match` au lieu de `fold`.
- Utiliser `Unit` (de `fpdart`) au lieu de `void` pour les retours de `TaskEither`.
- ne pas mettre de commentaires
