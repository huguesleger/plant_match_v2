import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/home_highlight.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/cubit/home_highlight_cubit.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/cubit/home_highlight_state.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/widgets/highlight_content.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/widgets/home_highlight_actions.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/widgets/home_highlight_card.dart';

class HomeHighlightSection extends StatelessWidget {
  const HomeHighlightSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<HomeHighlightCubit, HomeHighlightState>(
        builder: (context, state) => state.highlight.match(
          () => AppSkeletonizer(
            enabled: true,
            child: HomeHighlightCard(
              content: const FindYourPlant().content,
              onPressed: () {},
            ),
          ),
          (highlight) => HomeHighlightCard(
            content: highlight.content,
            onPressed: () => HomeHighlightActions.open(context, highlight),
          ),
        ),
      );
}
