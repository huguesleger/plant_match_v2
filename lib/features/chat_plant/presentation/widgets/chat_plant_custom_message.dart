import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/core/util/date_formatter.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/plant_message_card.dart';
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
    final metadata = message.metadata;
    if (metadata?['messageType'] == 'plant_exchange') {
      final pId = metadata?['plantId'] as String? ?? '';
      final pName = metadata?['plantName'] as String? ?? '';
      final pImage = metadata?['plantImage'] as String? ?? '';
      final isSender = message.author.id == currentUserId;

      final time = DateFormatter.formatTime(
        context,
        DateTime.fromMillisecondsSinceEpoch(message.createdAt ?? 0),
      );

      return PlantMessageCard(
        plantId: pId,
        plantName: pName,
        plantImage: pImage,
        isSender: isSender,
        time: time,
        status: message.status,
        onTap: () async {
          final catalogRepo = FirebaseCatalogRepository();
          try {
            final result = await catalogRepo.getCatalogById(pId).run();
            final catalog =
                result.map((opt) => opt.toNullable()).getOrElse((_) => null);

            if (catalog != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPlant(catalog: catalog),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Impossible de charger les détails')),
              );
            }
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}
