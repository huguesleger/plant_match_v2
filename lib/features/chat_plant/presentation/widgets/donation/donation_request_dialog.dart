import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/dialog/dialog_with_image.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';

Future<bool> showDonationRequestDialog(
  BuildContext context, {
  required String plantName,
  required String plantImage,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => DialogWithImage(
        image: _PlantImage(url: plantImage),
        title: t.chatPlant.donation_request.title,
        text: t.chatPlant.donation_request.content(plant: plantName),
        confirmLabel: Some(t.chatPlant.donation_request.send),
      ),
    ).then(
        (confirmed) => Option.fromNullable(confirmed).getOrElse(() => false));

class _PlantImage extends StatelessWidget {
  const _PlantImage({required this.url});

  final String url;

  static const double _size = 150;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Option.of(url).filter((value) => value.isNotEmpty).match(
              () => Assets.res.images.emptyPicture.image(
                width: _size,
                height: _size,
                fit: BoxFit.cover,
              ),
              (value) => AppNetworkImage(
                url: value,
                width: const Some(_size),
                height: const Some(_size),
              ),
            ),
      );
}
