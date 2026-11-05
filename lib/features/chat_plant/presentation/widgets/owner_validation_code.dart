import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/validation_code_display.dart';

class OwnerValidationCode extends StatefulWidget {
  const OwnerValidationCode({
    super.key,
    required this.watchCode,
    required this.generate,
  });

  final Stream<Option<String>> Function() watchCode;
  final Future<Option<String>> Function() generate;

  @override
  State<OwnerValidationCode> createState() => _OwnerValidationCodeState();
}

class _OwnerValidationCodeState extends State<OwnerValidationCode> {
  late final Stream<Option<String>> _code = widget.watchCode();
  bool _generating = false;

  Future<void> _generate() async {
    if (_generating) return;
    setState(() => _generating = true);
    final messenger = ScaffoldMessenger.of(context);
    final error = await widget.generate();
    if (!mounted) return;
    setState(() => _generating = false);
    error.match(
      () => null,
      (message) => messenger.showSnackBar(SnackBar(content: Text(message))),
    );
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Option<String>>(
        stream: _code,
        builder: (context, snapshot) =>
            Option.fromNullable(snapshot.data).match(
          () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          (code) => ValidationCodeDisplay(
            onGenerate: _generate,
            generating: _generating,
            code: code.toNullable(),
          ),
        ),
      );
}
