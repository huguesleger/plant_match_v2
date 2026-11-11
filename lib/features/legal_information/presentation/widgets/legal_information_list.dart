import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/legal_information/domain/entities/legal_document.dart';
import 'package:plant_match_v2/features/legal_information/presentation/legal_document_page_route.dart';
import 'package:plant_match_v2/features/legal_information/presentation/legal_document_presentation.dart';
import 'package:plant_match_v2/core/widgets/icon_list_item/icon_list_item.dart';

class LegalInformationList extends StatelessWidget {
  const LegalInformationList({super.key});

  static const double spacing = 32;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 32),
      child: ListView.separated(
        padding: AppSpacing.paddingAll,
        itemCount: LegalDocument.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: spacing),
        itemBuilder: (context, index) {
          final document = LegalDocument.values[index];
          return IconListItem(
            title: document.title,
            icon: document.icon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LegalDocumentPageRoute(document: document),
              ),
            ),
          );
        },
      ),
    );
  }
}
