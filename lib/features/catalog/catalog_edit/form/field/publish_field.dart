import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class PublishField extends StatelessWidget {
  const PublishField({
    super.key,
    required this.isPublish,
    required this.onChanged,
  });

  final bool isPublish;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderSwitch(
      name: 'publish',
      inactiveTrackColor: AppColors.white,
      title: Text(t.catalog.edit.publish_label),
      decoration: const InputDecoration(border: InputBorder.none),
      initialValue: isPublish,
      onChanged: (val) => onChanged(val ?? false),
    );
  }
}
