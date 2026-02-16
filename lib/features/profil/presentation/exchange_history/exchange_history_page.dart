import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_state.dart';

class ExchangeHistoryPage extends StatelessWidget {
  const ExchangeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (context) => ExchangeHistoryCubit(
        repository: FirebaseExchange(),
        userId: currentUserId,
      )..load(),
      child: const _ExchangeHistoryView(),
    );
  }
}

class _ExchangeHistoryView extends StatelessWidget {
  const _ExchangeHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique d\'échanges'),
      ),
      body: Column(
        children: [
          const _FilterChips(),
          Expanded(
            child: BlocBuilder<ExchangeHistoryCubit, ExchangeHistoryState>(
              builder: (context, state) {
                if (state is ExchangeHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ExchangeHistoryError) {
                  return Center(
                    child: Text(
                      'Erreur : ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is ExchangeHistoryLoaded) {
                  if (state.exchanges.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.history,
                            size: 64,
                            color: AppColors.greyMedium,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aucun échange dans l\'historique',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.exchanges.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ExchangeHistoryCard(
                        exchange: state.exchanges[index],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeHistoryCubit, ExchangeHistoryState>(
      builder: (context, state) {
        final currentFilter = state is ExchangeHistoryLoaded
            ? state.currentFilter
            : ExchangeStatusFilter.all;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tous',
                  isSelected: currentFilter == ExchangeStatusFilter.all,
                  onTap: () {
                    context
                        .read<ExchangeHistoryCubit>()
                        .load(filter: ExchangeStatusFilter.all);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Acceptés',
                  isSelected: currentFilter == ExchangeStatusFilter.accepted,
                  onTap: () {
                    context
                        .read<ExchangeHistoryCubit>()
                        .load(filter: ExchangeStatusFilter.accepted);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Terminés',
                  isSelected: currentFilter == ExchangeStatusFilter.completed,
                  onTap: () {
                    context
                        .read<ExchangeHistoryCubit>()
                        .load(filter: ExchangeStatusFilter.completed);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Refusés',
                  isSelected: currentFilter == ExchangeStatusFilter.rejected,
                  onTap: () {
                    context
                        .read<ExchangeHistoryCubit>()
                        .load(filter: ExchangeStatusFilter.rejected);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenMedium : AppColors.greyLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.greyDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ExchangeHistoryCard extends StatelessWidget {
  const _ExchangeHistoryCard({required this.exchange});

  final Exchange exchange;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isRequester = exchange.requestedBy == currentUserId;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (exchange.status) {
      case ExchangeStatus.accepted:
        statusColor = Colors.green;
        statusText = 'Accepté';
        statusIcon = Icons.check_circle;
        break;
      case ExchangeStatus.completed:
        statusColor = Colors.blue;
        statusText = 'Terminé';
        statusIcon = Icons.done_all;
        break;
      case ExchangeStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Refusé';
        statusIcon = Icons.cancel;
        break;
      case ExchangeStatus.pending:
        statusColor = Colors.orange;
        statusText = 'En attente';
        statusIcon = Icons.hourglass_empty;
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy').format(exchange.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isRequester
                  ? 'Vous avez proposé cet échange'
                  : 'Échange proposé par un utilisateur',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Affichage des deux plantes
            Row(
              children: [
                // Plante proposée (offeredPlant)
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          exchange.offeredPlantImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.greyLight,
                            child: const Icon(Icons.local_florist),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exchange.offeredPlantName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Proposée',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icône d'échange
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    LucideIcons.arrow_left_right,
                    color: AppColors.greenMedium,
                    size: 24,
                  ),
                ),
                // Plante demandée (targetPlant)
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          exchange.targetPlantImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.greyLight,
                            child: const Icon(Icons.local_florist),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exchange.targetPlantName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Demandée',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (exchange.status == ExchangeStatus.completed &&
                exchange.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Terminé le ${DateFormat('dd/MM/yyyy').format(exchange.completedAt!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
