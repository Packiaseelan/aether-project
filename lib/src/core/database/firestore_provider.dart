import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// @AETHER: Centralized Firestore provider to support Dependency Injection 
// and graceful fallback between real and fake instances.
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
