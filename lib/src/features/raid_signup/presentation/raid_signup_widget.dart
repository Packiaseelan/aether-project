import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/raid_providers.dart';
import '../../../core/design_system/theme/app_colors.dart';
import '../../../core/design_system/theme/app_text_styles.dart';
import '../../../core/design_system/tokens/spacing.dart';
import '../../../core/design_system/tokens/sizes.dart';

class RaidSignupWidget extends ConsumerStatefulWidget {
  const RaidSignupWidget({super.key});

  @override
  ConsumerState<RaidSignupWidget> createState() => _RaidSignupWidgetState();
}

class _RaidSignupWidgetState extends ConsumerState<RaidSignupWidget> {
  bool _isJoining = false;

  Future<void> _handleJoin() async {
    setState(() => _isJoining = true);
    
    final service = ref.read(raidServiceProvider);
    // In production, userId would come from an Auth provider.
    final success = await service.joinRaid(userId: 'current_user_id'); 

    if (mounted) {
      setState(() => _isJoining = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Successfully joined the raid!' : 'Failed to join: Raid might be full.'),
          backgroundColor: success ? AppColors.success : AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(raidSlotsProvider);
    const maxSlots = 15;

    return Column(
      children: [
        slotsAsync.when(
          data: (slots) => Column(
            children: [
              Text(
                'Raid Slots: $slots / $maxSlots',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: AppSpacing.small),
              LinearProgressIndicator(
                value: slots / maxSlots,
                backgroundColor: AppColors.progressBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
        const SizedBox(height: AppSpacing.medium),
        ElevatedButton(
          onPressed: _isJoining ? null : _handleJoin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textAction,
            minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          ),
          child: _isJoining 
            ? const CircularProgressIndicator(color: AppColors.textAction) 
            : const Text('JOIN RAID', style: AppTextStyles.buttonText),
        ),
      ],
    );
  }
}
