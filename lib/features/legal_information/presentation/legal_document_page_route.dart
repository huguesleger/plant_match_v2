import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/legal_information/domain/entities/legal_document.dart';
import 'package:plant_match_v2/features/legal_information/presentation/cubit/legal_document_cubit.dart';
import 'package:plant_match_v2/features/legal_information/presentation/legal_document_screen.dart';

class LegalDocumentPageRoute extends StatelessWidget {
  const LegalDocumentPageRoute({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LegalDocumentCubit(document),
        child: const LegalDocumentScreen(),
      );
}
