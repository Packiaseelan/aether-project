import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_project/src/core/database/firestore_provider.dart';
import '../../../core/design_system/theme/app_colors.dart';
import '../../../core/design_system/theme/app_text_styles.dart';
import '../../../core/design_system/tokens/spacing.dart';
import '../../../core/design_system/tokens/sizes.dart';
import '../../../core/design_system/tokens/radius.dart';

// @AETHER: Scalability optimization: Limit real-time listeners to last 20 messages.
// Avoids O(N^2) read costs for 10,000 concurrent users.
final chatMessagesProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('chat')
      .orderBy('timestamp', descending: true)
      .limit(20)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

class ChatWidget extends ConsumerWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);

    return Container(
      height: AppSizes.chatContainerHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      (msg['text'] as String?) ?? '',
                      style: AppTextStyles.bodySmall,
                    ),
                    subtitle: Text(
                      (msg['user'] as String?) ?? 'Unknown User',
                      style: AppTextStyles.caption,
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      hintStyle: AppTextStyles.sectionLabel,
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, size: AppSizes.iconSmall, color: AppColors.primary),
                  onPressed: () {
                    // @AETHER: Future implementation: Send message to Firestore
                    // Scalability note: Implement client-side throttling here.
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
