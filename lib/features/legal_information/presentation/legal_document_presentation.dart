import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/legal_information/domain/entities/legal_document.dart';

extension LegalDocumentPresentation on LegalDocument {
  String get title => switch (this) {
        PrivacyPolicy() => t.legalInformation.items.privacy_policy,
        TermsOfUse() => t.legalInformation.items.terms,
        LegalNotice() => t.legalInformation.items.legal_notice,
      };

  IconData get icon => switch (this) {
        PrivacyPolicy() => LucideIcons.shield_check,
        TermsOfUse() => LucideIcons.file_text,
        LegalNotice() => LucideIcons.scale,
      };
}
