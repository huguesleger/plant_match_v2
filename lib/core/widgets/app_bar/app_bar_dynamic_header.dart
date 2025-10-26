import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppBarDynamicHeader extends StatefulWidget {
  const AppBarDynamicHeader({
    super.key,
    required this.body,
    required this.backgroundAppBar,
    this.leading = true,
    this.leadingButton,
    this.leadingWidth = 80,
    required this.titlePadding,
    required this.height,
  });

  final Widget body;
  final Widget backgroundAppBar;
  final bool leading;
  final Widget? leadingButton;
  final double leadingWidth;

  final EdgeInsets titlePadding;
  final double height;

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
          leading: widget.leading == true
              ? widget.leadingButton
              : const SizedBox.shrink(),
          leadingWidth: widget.leadingWidth,
          pinned: true,
          floating: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          expandedHeight: widget.height,
          collapsedHeight: 90,
          shadowColor: AppColors.black.withValues(alpha: 0.6),
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.2,
            centerTitle: true,
            titlePadding: _isShrink ? null : widget.titlePadding,
            title: _isShrink
                ? SvgPicture.asset(
                    'assets/logo/logo_color.svg',
                    width: 60,
                  )
                : SvgPicture.asset('assets/logo/logo_white.svg'),
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
