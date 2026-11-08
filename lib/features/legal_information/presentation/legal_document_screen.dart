import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/legal_information/presentation/cubit/legal_document_cubit.dart';
import 'package:plant_match_v2/features/legal_information/presentation/cubit/legal_document_state.dart';
import 'package:plant_match_v2/features/legal_information/presentation/legal_document_presentation.dart';
import 'package:plant_match_v2/features/legal_information/presentation/widgets/legal_document_web_view.dart';

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LegalDocumentCubit>();
    return BlocBuilder<LegalDocumentCubit, LegalDocumentState>(
      builder: (context, state) => switch (state) {
        LegalDocumentError() => ErrorPage(
            failure: const NetworkFailure('legal document load failed'),
            onRetry: cubit.retry,
          ),
        LegalDocumentLoading() || LegalDocumentLoaded() => Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBarTemplate(
              title: Some(cubit.document.title),
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              shadowColor: const Some(AppColors.black),
              styleIconButton: Some(IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: AppColors.greyLight),
              )),
              onPressed: Some(() => Navigator.pop(context)),
            ),
            body: LegalDocumentWebView(
              controller: cubit.controller,
              isLoading: state is LegalDocumentLoading,
            ),
          ),
      },
    );
  }
}
