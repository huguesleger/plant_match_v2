import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/chat/data/firebase_chat.dart';
import 'package:plant_match_v2/features/chat/presentation/chat_page.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/extension/user_extension.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/filters/catalog_filter_bar.dart';
import 'package:plant_match_v2/features/user/presentation/header/user_header_with_content.dart';
import 'package:plant_match_v2/features/user/presentation/items_count/items_count.dart';
import 'package:plant_match_v2/features/user/presentation/list_plants/catalog_list.dart';
import 'package:plant_match_v2/features/user/presentation/recent_plants/recent_plants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.data});

  final User data;

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final published = data.publishedCatalogs(user.uid);
    final recent = data.recentCatalogs(user.uid);
    final filtered = data.filteredCatalogs(user.uid);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: UserHeaderWithContent(
        user: user,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Text(
                  (user.bio != null && user.bio!.isNotEmpty)
                      ? user.bio!
                      : 'Pas encore de description...',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ItemsCount(
              catalog: published,
              level: data.level,
            ),
            if (recent.isNotEmpty) ...[
              RecentPlants(
                catalogs: recent,
              ),
            ],
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CatalogFiltersBar(
                  selected: data.selectedFilter,
                  onChanged: (filter) =>
                      context.read<UserCubit>().updateFilter(filter),
                ),
                const SizedBox(height: 16),
                CatalogList(catalogs: filtered),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) return;
          final chatRepository = FirebaseChat();
          final chatId = await chatRepository.getOrCreateChat(
            currentUser.uid,
            data.user.uid,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPage(
                chatId: chatId,
                otherUserId: data.user.uid,
                otherUserName: data.user.userName.isNotEmpty
                    ? data.user.userName.toCapitalize()
                    : data.user.fullName
                        .getFirstWordBeforeSpace()
                        .toCapitalize(),
                otherUserAvatar: data.user.profilImg,
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        backgroundColor: AppColors.greenLight,
        child: const Icon(
          LucideIcons.message_square_text,
          color: AppColors.blueGreen,
        ),
      ),
    );
  }
}
