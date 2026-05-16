import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../core/design_system/theme/app_colors.dart';
import '../../../core/design_system/theme/app_text_styles.dart';
import '../../../core/design_system/tokens/radius.dart';
import '../../../core/design_system/tokens/spacing.dart';

class BossTimerWidget extends StatefulWidget {
  const BossTimerWidget({super.key});

  @override
  State<BossTimerWidget> createState() => _BossTimerWidgetState();
}

class _BossTimerWidgetState extends State<BossTimerWidget> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final ValueNotifier<Duration> _remainingNotifier;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    final initialRemaining = const Duration(minutes: 5);
    _endTime = DateTime.now().add(initialRemaining);
    _remainingNotifier = ValueNotifier<Duration>(initialRemaining);
    
    _ticker = createTicker((elapsed) {
      final now = DateTime.now();
      if (now.isAfter(_endTime)) {
        _remainingNotifier.value = Duration.zero;
        _ticker.stop();
      } else {
        _remainingNotifier.value = _endTime.difference(now);
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _remainingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'WORLD BOSS DESPAWN',
            style: AppTextStyles.raidStatus,
          ),
          const SizedBox(height: AppSpacing.small),
          // @AETHER: Isolated 100ms rebuild scope.
          // Only this ValueListenableBuilder and its child rebuild every 100ms.
          RepaintBoundary(
            child: ValueListenableBuilder<Duration>(
              valueListenable: _remainingNotifier,
              builder: (context, remaining, _) {
                final minutes = remaining.inMinutes.toString().padLeft(2, '0');
                final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
                final hundredths = ((remaining.inMilliseconds % 1000) ~/ 100).toString();
                
                return Text(
                  '$minutes:$seconds.$hundredths',
                  style: AppTextStyles.countdownTimer,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
