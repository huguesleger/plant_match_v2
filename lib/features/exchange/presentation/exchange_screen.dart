import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    required this.offeredPlant,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

  final Catalog offeredPlant;

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final _catalogRepo = FirebaseCatalogRepository();
  Catalog? _targetPlant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTargetPlant();
  }

  Future<void> _loadTargetPlant() async {
    try {
      final plant = await _catalogRepo.getCatalogById(widget.targetPlantId);
      setState(() {
        _targetPlant = plant;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmer l'échange")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Tu proposes cette plante",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.offeredPlant.images.isNotEmpty
                        ? NetworkImage(widget.offeredPlant.images.first)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(widget.offeredPlant.name),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _targetPlant == null
                        ? null
                        : () async {
                            final user = FirebaseAuth.instance.currentUser!;

                            final exchange = Exchange(
                              chatId: widget.chatId,
                              requestedBy: user.uid,
                              ownerId: widget.targetOwnerId,
                              targetPlantId: widget.targetPlantId,
                              targetPlantName: _targetPlant!.name,
                              targetPlantImage: _targetPlant!.images.isNotEmpty
                                  ? _targetPlant!.images.first
                                  : '',
                              offeredPlantId: widget.offeredPlant.catalogId!,
                              offeredPlantName: widget.offeredPlant.name,
                              offeredPlantImage:
                                  widget.offeredPlant.images.isNotEmpty
                                      ? widget.offeredPlant.images.first
                                      : '',
                              status: ExchangeStatus.pending,
                              createdAt: DateTime.now(),
                              seenByOwner: false,
                              seenByRequester: true,
                            );

                            await context
                                .read<ExchangeCubit>()
                                .propose(exchange);

                            if (!context.mounted) return;

                            Navigator.pop(context, true);
                          },
                    child: const Text("Confirmer l'échange"),
                  ),
                ],
              ),
            ),
    );
  }
}
