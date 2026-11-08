sealed class LegalDocument {
  const LegalDocument(this.path);

  static const String baseUrl = 'https://plantmatch-app.vercel.app';

  static const List<LegalDocument> values = [
    PrivacyPolicy(),
    TermsOfUse(),
    LegalNotice(),
  ];

  final String path;

  /// `app=1` indique au site qu'il est affiché dans la webview de l'app :
  /// il masque alors le bouton « Retour à l'accueil ».
  Uri get url => Uri.parse('$baseUrl/$path?app=1');
}

class PrivacyPolicy extends LegalDocument {
  const PrivacyPolicy() : super('politique-confidentialite');
}

class TermsOfUse extends LegalDocument {
  const TermsOfUse() : super('conditions-utilisation');
}

class LegalNotice extends LegalDocument {
  const LegalNotice() : super('mentions-legales');
}
