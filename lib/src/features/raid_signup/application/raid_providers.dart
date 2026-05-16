import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'raid_service.dart';
import '../../../core/database/firestore_provider.dart';

/// Provider for the RaidService with constructor injection.
final raidServiceProvider = Provider<RaidService>((ref) {
  return RaidService(firestore: ref.watch(firestoreProvider));
});

/// Reactive StreamProvider to monitor slot availability in real-time.
/// @AETHER: Isolated reactive flow for slot management.
final raidSlotsProvider = StreamProvider.autoDispose<int>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('events')
      .doc('dragon_raid')
      .snapshots()
      .map((snapshot) => (snapshot.data()?['slots_filled'] as num?)?.toInt() ?? 0);
});
