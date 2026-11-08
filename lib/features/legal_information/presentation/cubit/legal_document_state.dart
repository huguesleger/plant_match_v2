sealed class LegalDocumentState {
  const LegalDocumentState();
}

class LegalDocumentLoading extends LegalDocumentState {
  const LegalDocumentLoading();
}

class LegalDocumentLoaded extends LegalDocumentState {
  const LegalDocumentLoaded();
}

class LegalDocumentError extends LegalDocumentState {
  const LegalDocumentError();
}
