# PlantMatch V2

Application Flutter. Gestion d'état avec `flutter_bloc` (Cubit), programmation fonctionnelle avec `fpdart`, backend Firebase.

## Commandes

- Analyse : `flutter analyze --no-pub <chemins>` (`--no-pub` évite de modifier `pubspec.lock`).
- i18n : les textes sont dans `lib/features/<feature>/<feature>_fr.i18n.json`. Après modification, lancer `dart run slang` pour régénérer `lib/core/i18n/translations*.g.dart`. Ne jamais éditer les fichiers `.g.dart` à la main.

## Architecture

- Chaque fonctionnalité vit dans `lib/features/<feature>/`, découpée en trois couches :
  - `data/` : sources de données, mappers, implémentations des repositories.
  - `domain/` : entités et interfaces des repositories. Pas de `use_cases` sauf demande explicite.
  - `presentation/` : widgets Flutter et Cubits.

## Couche présentation

- Gestion d'état : toujours un `Cubit` (pas de `Bloc` à événements).
- Découpage d'une page :
  - `<feature>_page_route.dart` : la route de la feature.
  - `<feature>_screen.dart` : l'écran, qui définit uniquement la structure globale et délègue header, contenu, footer, etc. à des widgets dédiés.
- Un widget ne dépasse pas 100 lignes.
- Construire l'écran à partir de l'état du Cubit avec `BlocBuilder`.

## Programmation fonctionnelle (fpdart)

- Jamais de `null` : utiliser `Option<T>`.
- Erreurs : `Either`, et `TaskEither` pour l'asynchrone.
- Retour sans valeur d'un `TaskEither` : `Unit`, jamais `void`.
- `match` plutôt que `fold`.
- Composer les opérations simplement. C'est le Cubit qui appelle `run()`, en bout de chaîne.

### Émission des états dans un Cubit

Le `match` produit l'état, `emit` est appelé une seule fois via `map` :

```dart
// À faire
someRepo
  .loadSomething()
  .match(
    (failure) => ErrorState(failure.message),
    (success) => SuccessState(success),
  )
  .map(emit)
  .run();

// À ne pas faire
someRepo
  .loadSomething()
  .match(
    (failure) => emit(ErrorState(failure.message)),
    (success) => emit(SuccessState(success)),
  )
  .run();
```

## Style de code

- États immuables.
- Types somme plutôt que types produit : `sealed class` plutôt qu'`enum`.
- Jamais de `default` dans un `switch` sur une `sealed class`, pour garder l'exhaustivité.
- Expressions plutôt qu'instructions ; ternaire plutôt que `if`/`else`.
- **Aucun commentaire** a part les TODO dans le code créé ou modifié : le code doit se suffire à lui-même.

## Git

- Ne jamais commit, ni proposer de commit : l'utilisateur commit lui-même (GitKraken).
