import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/legal_information/domain/entities/legal_document.dart';
import 'package:plant_match_v2/features/legal_information/presentation/legal_document_page_route.dart';

class CguCheckboxField extends StatelessWidget {
  const CguCheckboxField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  void _openDocument(BuildContext context, LegalDocument document) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LegalDocumentPageRoute(document: document),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (value) {
                onChanged(value == true);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              strutStyle: const StrutStyle(height: 1.5),
              text: TextSpan(
                text: t.auth.register.cgu.accept,
                style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => _openDocument(context, const TermsOfUse()),
                    text: t.auth.register.cgu.terms,
                    style: const TextStyle(
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: t.auth.register.cgu.and,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => _openDocument(context, const PrivacyPolicy()),
                    text: t.auth.register.cgu.privacy,
                    style: const TextStyle(
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: t.auth.register.cgu.of,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
