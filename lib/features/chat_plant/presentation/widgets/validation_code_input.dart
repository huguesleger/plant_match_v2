import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ValidationCodeInput extends StatefulWidget {
  const ValidationCodeInput({
    super.key,
    required this.onValidate,
  });

  final Future<Option<String>> Function(String code) onValidate;

  @override
  State<ValidationCodeInput> createState() => _ValidationCodeInputState();
}

class _ValidationCodeInputState extends State<ValidationCodeInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isValidating = false;
  Option<String> _error = const None();

  Future<void> _handleValidate() async {
    if (_isValidating || _controller.text.length != 6) return;
    setState(() {
      _isValidating = true;
      _error = const None();
    });
    final error = await widget.onValidate(_controller.text);
    if (!mounted) return;
    setState(() {
      _isValidating = false;
      _error = error;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueGreen.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            t.chatPlant.validation.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            t.chatPlant.validation.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
                color: AppColors.blueGreen,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: t.chatPlant.validation.hint,
                hintStyle:
                    TextStyle(color: AppColors.grey.withValues(alpha: 0.3)),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blueGreen.withValues(alpha: 0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blueGreen, width: 2),
                ),
              ),
              onChanged: (value) =>
                  value.length == 6 ? _handleValidate() : null,
            ),
          ),
          ..._error.match(
            () => const <Widget>[],
            (message) => [
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isValidating ? null : _handleValidate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blueGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isValidating
                ? const SizedBox(
                    height: 20,
                    width: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Text(t.chatPlant.validation.confirm_btn),
          ),
        ],
      ),
    );
  }
}
