import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/favorite/data/firebase_favorites_repo.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

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
  final Catalog? catalog;
  final ProfilUser? targetUser;
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

    final catalogId =
        Option.fromNullable(widget.catalog).flatMap((c) => c.catalogId);
    final targetUid = Option.fromNullable(widget.targetUser).map((u) => u.uid);

    final isFavoriteTask = catalogId.match(
      () => targetUid.match(
        () => TaskEither<Failure, bool>.right(_isFavorite),
        (tUid) => _repo.isFavoriteUser(uid, tUid),
      ),
      (id) => _repo.isFavoritePlant(uid, id),
    );

    final result = await isFavoriteTask.run();
    result.match(
      (failure) => {},
      (fav) => mounted ? setState(() => _isFavorite = fav) : {},
    );
  }

  Future<void> _toggleFavorite() async {
    final uid = widget.currentUserId;

    if (uid == null || uid.isEmpty) {
      setState(() => _isFavorite = !_isFavorite);
      widget.onChanged?.call(_isFavorite);
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newValue = !_isFavorite;
      final catalogOpt = Option.fromNullable(widget.catalog);
      final targetUserOpt = Option.fromNullable(widget.targetUser);

      final task = catalogOpt.match(
        () => targetUserOpt.match(
          () => TaskEither<Failure, Unit>.right(unit),
          (user) => newValue
              ? _repo.addFavoriteUser(uid, user)
              : _repo.removeFavoriteUser(uid, user.uid),
        ),
        (catalog) => catalog.catalogId.match(
          () => TaskEither<Failure, Unit>.right(unit),
          (id) => newValue
              ? _repo.addFavoritePlant(uid, catalog)
              : _repo.removeFavoritePlant(uid, id),
        ),
      );

      final result = await task.run();
      result.match(
        (failure) => throw Exception(failure.message),
        (_) {
          if (mounted) {
            setState(() => _isFavorite = newValue);
            widget.onChanged?.call(newValue);
          }
        },
      );
    } catch (_) {
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
