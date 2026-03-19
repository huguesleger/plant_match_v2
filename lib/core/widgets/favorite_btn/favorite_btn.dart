import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/data/firebase_favorites_repo.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

/// Bouton favori générique.
///
/// - Pour **une plante** : passer [catalog] + [currentUserId]
/// - Pour **un profil** : passer [targetUser] + [currentUserId]
/// - Si aucun de ces paramètres n'est fourni, le bouton est purement visuel (mode legacy).
class FavoriteBtn extends StatefulWidget {
  const FavoriteBtn({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.catalog,
    this.targetUser,
    this.currentUserId,
  });

  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  /// Plante à mettre en favori (mode plante)
  final Catalog? catalog;

  /// Profil à mettre en favori (mode profil)
  final ProfilUser? targetUser;

  /// UID de l'utilisateur connecté
  final String? currentUserId;

  @override
  State<FavoriteBtn> createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<FavoriteBtn>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  bool _isLoading = false;
  final _repo = FirebaseFavoritesRepo();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialValue;
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final uid = widget.currentUserId;
    if (uid == null || uid.isEmpty) return;

    bool? result;

    if (widget.catalog?.catalogId != null) {
      final resultTE = await _repo.isFavoritePlant(uid, widget.catalog!.catalogId!).run();
      result = resultTE.getOrElse((_) => false);
    } else if (widget.targetUser != null) {
      final resultTE = await _repo.isFavoriteUser(uid, widget.targetUser!.uid).run();
      result = resultTE.getOrElse((_) => false);
    }

    if (result != null && mounted) {
      setState(() => _isFavorite = result!);
    }
  }

  Future<void> _toggleFavorite() async {
    final uid = widget.currentUserId;

    // Mode legacy (sans Firebase)
    if (uid == null || uid.isEmpty) {
      setState(() => _isFavorite = !_isFavorite);
      widget.onChanged?.call(_isFavorite);
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newValue = !_isFavorite;

      if (widget.catalog != null && widget.catalog!.catalogId != null) {
        // Mode plante
        if (newValue) {
          final result = await _repo.addFavoritePlant(uid, widget.catalog!).run();
          if (result.isLeft()) throw Exception('Erreur ajout plante');
        } else {
          final result = await _repo.removeFavoritePlant(uid, widget.catalog!.catalogId!).run();
          if (result.isLeft()) throw Exception('Erreur suppression plante');
        }
      } else if (widget.targetUser != null) {
        // Mode profil
        if (newValue) {
          final result = await _repo.addFavoriteUser(uid, widget.targetUser!).run();
          if (result.isLeft()) throw Exception('Erreur ajout utilisateur');
        } else {
          final result = await _repo.removeFavoriteUser(uid, widget.targetUser!.uid).run();
          if (result.isLeft()) throw Exception('Erreur suppression utilisateur');
        }
      }

      if (mounted) {
        setState(() => _isFavorite = newValue);
        widget.onChanged?.call(newValue);
      }
    } catch (_) {
      // Silencieux — l'UI ne change pas en cas d'erreur
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: _isLoading
          ? const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.greenMedium,
              ),
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: child,
              ),
              child: Icon(
                _isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                key: ValueKey(_isFavorite),
                color: _isFavorite ? AppColors.greenMedium : AppColors.grey,
                size: 28,
              ),
            ),
    );
  }
}
