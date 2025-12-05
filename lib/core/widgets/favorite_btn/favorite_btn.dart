import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class FavoriteBtn extends StatefulWidget {
  const FavoriteBtn({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  @override
  State<FavoriteBtn> createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<FavoriteBtn>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialValue;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: child,
        ),
        child: Icon(
          _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          key: ValueKey(_isFavorite),
          color: _isFavorite ? AppColors.greenMedium : AppColors.grey,
          size: 28,
        ),
      ),
    );
  }
}
