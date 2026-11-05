import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/util/date_formatter.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/plant_message_card.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class ChatPlantCustomMessage extends StatelessWidget {
  const ChatPlantCustomMessage({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final types.CustomMessage message;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final metadata = Option.fromNullable(message.metadata)
        .getOrElse(() => <String, dynamic>{});
    String metadataString(String key) => Option<dynamic>.fromNullable(
          metadata[key],
        ).map((value) => value as String).getOrElse(() => '');
    final messageType = Option<dynamic>.fromNullable(metadata['messageType']);
    if (messageType
        .filter(
          (type) =>
              type == ChatMessageType.plantExchange.name ||
              type == ChatMessageType.plantDonation.name,
        )
        .isSome()) {
      final pId = metadataString('plantId');
      final pName = metadataString('plantName');
      final pImage = metadataString('plantImage');
      final isSender = message.author.id == currentUserId;

      final time = DateFormatter.formatTime(
        context,
        DateTime.fromMillisecondsSinceEpoch(
            Option.fromNullable(message.createdAt).getOrElse(() => 0)),
      );

      return PlantMessageCard(
        plantId: pId,
        plantName: pName,
        plantImage: pImage,
        isSender: isSender,
        time: time,
        status: Option.fromNullable(message.status),
        onTap: () async {
          final catalogRepo = FirebaseCatalogRepository();
          try {
            final result = await catalogRepo.getCatalogById(pId).run();
            final catalog = result.getOrElse((_) => const None());

            catalog.filter((_) => context.mounted).map(
                  (catalog) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPlant(catalog: catalog),
                    ),
                  ),
                );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.chatPlant.plant_card.error_loading)),
              );
            }
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}
