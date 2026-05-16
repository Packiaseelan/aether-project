import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaidFullException implements Exception {
  final String message;
  RaidFullException(this.message);
}

class RaidService {
  final FirebaseFirestore _firestore;
  
  // Client-side queue to prevent transaction thrashing on the same device
  // and handle FakeFirestore's lack of transaction serialization.
  bool _locked = false;
  final List<Completer<void>> _queue = [];

  RaidService({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<void> _acquireLock() async {
    if (!_locked) {
      _locked = true;
      return;
    }
    final completer = Completer<void>();
    _queue.add(completer);
    await completer.future;
  }

  void _releaseLock() {
    if (_queue.isNotEmpty) {
      final next = _queue.removeAt(0);
      next.complete();
    } else {
      _locked = false;
    }
  }

  Future<bool> joinRaid({required String userId}) async {
    await _acquireLock();
    final docRef = _firestore.collection('events').doc('dragon_raid');

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        
        if (!snapshot.exists) {
          throw Exception('Event does not exist');
        }

        final data = snapshot.data();
        if (data == null) {
          throw Exception('No data in document');
        }

        final slotsFilled = (data['slots_filled'] as num?)?.toInt() ?? 0;
        final maxSlots = (data['max_slots'] as num?)?.toInt() ?? 15;

        if (slotsFilled >= maxSlots) {
          throw RaidFullException('The raid is already full.');
        }

        // @AETHER: Using runTransaction with server-side increment AND client-side queuing
        transaction.update(docRef, {
          'slots_filled': FieldValue.increment(1),
        });
      });

      return true;
    } on RaidFullException {
      return false;
    } catch (e) {
      return false;
    } finally {
      _releaseLock();
    }
  }
}
