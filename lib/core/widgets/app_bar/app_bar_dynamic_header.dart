import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';

class AppBarDynamicHeader extends StatefulWidget {
  const AppBarDynamicHeader({
    super.key,
    required this.body,
    required this.backgroundAppBar,
    this.leading = true,
    this.leadingButton = const None(),
    this.leadingWidth = 76,
    this.actions = const None(),
    this.actionsPadding = AppSpacing.paddingHorizontal,
    this.collapsedHeight = 90,
    required this.titlePadding,
    this.titlePaddingShrink = const None(),
    required this.height,
    required this.visual,
    required this.shrinkVisual,
  });

  final Widget body;
  final Widget backgroundAppBar;
  final bool leading;
  final Option<Widget> leadingButton;
  final double leadingWidth;
  final EdgeInsets titlePadding;
  final Option<EdgeInsets> titlePaddingShrink;
  final double height;
  final Option<List<Widget>> actions;
  final EdgeInsets actionsPadding;
  final Widget visual;
  final Widget shrinkVisual;
  final double collapsedHeight;

  @override
  State<AppBarDynamicHeader> createState() => _AppBarDynamicHeaderState();
}

class _AppBarDynamicHeaderState extends State<AppBarDynamicHeader> {
  late ScrollController _scrollController;
  bool lastStatus = true;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (widget.height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          leading: widget.leading
              ? widget.leadingButton.toNullable()
              : const SizedBox.shrink(),
          leadingWidth: widget.leadingWidth,
          pinned: true,
          floating: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          expandedHeight: widget.height,
          collapsedHeight: widget.collapsedHeight,
          actions: widget.actions.toNullable(),
          actionsPadding:
              widget.actions.map((_) => widget.actionsPadding).toNullable(),
          shadowColor: AppColors.black.withValues(alpha: 0.6),
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.2,
            centerTitle: true,
            titlePadding: _isShrink
                ? widget.titlePaddingShrink.toNullable()
                : widget.titlePadding,
            title: _isShrink ? widget.shrinkVisual : widget.visual,
            background: widget.backgroundAppBar,
          ),
        )
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
