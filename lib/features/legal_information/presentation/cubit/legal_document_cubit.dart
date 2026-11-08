import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/legal_information/domain/entities/legal_document.dart';
import 'package:plant_match_v2/features/legal_information/presentation/cubit/legal_document_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalDocumentCubit extends SafeCubit<LegalDocumentState> {
  LegalDocumentCubit(this.document) : super(const LegalDocumentLoading()) {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => emit(const LegalDocumentLoading()),
          onPageFinished: (_) => state is LegalDocumentError
              ? null
              : emit(const LegalDocumentLoaded()),
          onWebResourceError: (error) => (error.isForMainFrame ?? true)
              ? emit(const LegalDocumentError())
              : null,
        ),
      )
      ..loadRequest(document.url);
  }

  final LegalDocument document;
  final WebViewController controller = WebViewController();

  void retry() {
    emit(const LegalDocumentLoading());
    controller.loadRequest(document.url);
  }
}
