import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_state.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';

class ExchangeHistoryPage extends StatelessWidget {
  const ExchangeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (context) => ExchangeHistoryCubit(
        exchangeRepository: FirebaseExchange(),
        donationRepository: FirebaseDonation(),
        userId: currentUserId,
      )..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
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
                  if (state.items.isEmpty) {
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
                            'Aucun échange ni donation dans l\'historique',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.greyDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return item.type == HistoryItemType.exchange
                          ? _ExchangeHistoryCard(exchange: item.exchange!)
                          : _DonationHistoryCard(donation: item.donation!);
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

// ─────────────────────────────────────────────────────────────────────────────
// Filtres
// ─────────────────────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeHistoryCubit, ExchangeHistoryState>(
      builder: (context, state) {
        final currentFilter = state is ExchangeHistoryLoaded
            ? state.currentFilter
            : HistoryStatusFilter.all;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  label: 'Tous',
                  isSelected: currentFilter == HistoryStatusFilter.all,
                  onTap: () => context
                      .read<ExchangeHistoryCubit>()
                      .load(filter: HistoryStatusFilter.all),
                ),
                const SizedBox(width: 8),
                _Chip(
                  label: 'Acceptés',
                  isSelected: currentFilter == HistoryStatusFilter.accepted,
                  onTap: () => context
                      .read<ExchangeHistoryCubit>()
                      .load(filter: HistoryStatusFilter.accepted),
                ),
                const SizedBox(width: 8),
                _Chip(
                  label: 'Terminés',
                  isSelected: currentFilter == HistoryStatusFilter.completed,
                  onTap: () => context
                      .read<ExchangeHistoryCubit>()
                      .load(filter: HistoryStatusFilter.completed),
                ),
                const SizedBox(width: 8),
                _Chip(
                  label: 'Refusés',
                  isSelected: currentFilter == HistoryStatusFilter.rejected,
                  onTap: () => context
                      .read<ExchangeHistoryCubit>()
                      .load(filter: HistoryStatusFilter.rejected),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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

// ─────────────────────────────────────────────────────────────────────────────
// Helpers statut
// ─────────────────────────────────────────────────────────────────────────────

({Color color, String text, IconData icon}) _statusStyle(String rawStatus) {
  return switch (rawStatus) {
    'accepted' => (
        color: Colors.green,
        text: 'Accepté',
        icon: Icons.check_circle,
      ),
    'completed' => (
        color: Colors.blue,
        text: 'Terminé',
        icon: Icons.done_all,
      ),
    'rejected' => (
        color: Colors.red,
        text: 'Refusé',
        icon: Icons.cancel,
      ),
    _ => (
        color: Colors.orange,
        text: 'En attente',
        icon: Icons.hourglass_empty,
      ),
  };
}

Widget _statusBadge(String rawStatus) {
  final s = _statusStyle(rawStatus);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: s.color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(s.icon, size: 16, color: s.color),
        const SizedBox(width: 6),
        Text(
          s.text,
          style: TextStyle(
            color: s.color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

Widget _plantThumb(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      url,
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
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Échange
// ─────────────────────────────────────────────────────────────────────────────

class _ExchangeHistoryCard extends StatelessWidget {
  const _ExchangeHistoryCard({required this.exchange});

  final Exchange exchange;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isRequester = exchange.requestedBy == currentUserId;

    return _HistoryCardShell(
      rawStatus: exchange.status.name,
      date: exchange.createdAt,
      completedAt: exchange.completedAt,
      typeLabel: 'Échange',
      typeIcon: LucideIcons.arrow_left_right,
      typeColor: AppColors.greenDark,
      roleText: isRequester
          ? 'Vous avez proposé cet échange'
          : 'Échange proposé par un utilisateur',
      content: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _plantThumb(exchange.offeredPlantImage),
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
                  style: TextStyle(fontSize: 12, color: AppColors.greyDark),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              LucideIcons.arrow_left_right,
              color: AppColors.greenMedium,
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _plantThumb(exchange.targetPlantImage),
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
                  style: TextStyle(fontSize: 12, color: AppColors.greyDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Donation
// ─────────────────────────────────────────────────────────────────────────────

class _DonationHistoryCard extends StatelessWidget {
  const _DonationHistoryCard({required this.donation});

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isRequester = donation.requestedBy == currentUserId;

    return _HistoryCardShell(
      rawStatus: donation.status.name,
      date: donation.createdAt,
      completedAt: donation.completedAt,
      typeLabel: 'Donation',
      typeIcon: Icons.volunteer_activism_rounded,
      typeColor: AppColors.blueGreen,
      roleText: isRequester
          ? 'Vous avez demandé cette donation'
          : 'Demande de donation reçue',
      content: Column(
        children: [
          _plantThumb(donation.plantImage),
          const SizedBox(height: 8),
          Text(
            donation.plantName,
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
            'Plante donnée',
            style: TextStyle(fontSize: 12, color: AppColors.greyDark),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell commun aux deux cards
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryCardShell extends StatelessWidget {
  const _HistoryCardShell({
    required this.rawStatus,
    required this.date,
    required this.completedAt,
    required this.typeLabel,
    required this.typeIcon,
    required this.typeColor,
    required this.roleText,
    required this.content,
  });

  final String rawStatus;
  final DateTime date;
  final DateTime? completedAt;
  final String typeLabel;
  final IconData typeIcon;
  final Color typeColor;
  final String roleText;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne type + statut + date
            Row(
              children: [
                // Badge type (Échange / Donation)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 14, color: typeColor),
                      const SizedBox(width: 5),
                      Text(
                        typeLabel,
                        style: TextStyle(
                          color: typeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _statusBadge(rawStatus),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              roleText,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            content,
            if (rawStatus == 'completed' && completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Terminé le ${DateFormat('dd/MM/yyyy').format(completedAt!)}',
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
