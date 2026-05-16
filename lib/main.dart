import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aether_project/src/core/database/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/features/boss_timer/presentation/boss_timer_widget.dart';
import 'src/features/chat/presentation/chat_widget.dart';
import 'src/features/raid_signup/presentation/raid_signup_widget.dart';
import 'src/core/design_system/theme/app_colors.dart';
import 'src/core/design_system/theme/app_text_styles.dart';
import 'src/core/design_system/tokens/spacing.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FirebaseFirestore firestore;
  
  try {
    await Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;
  } catch (e) {
    // @AETHER: Graceful fallback for local development without real Firebase config.
    // This allows the app to run in "Demo Mode" using the same Fake used in tests.
    firestore = FakeFirebaseFirestore();
    
    // Seed the fake data so the UI isn't empty
    await firestore.collection('events').doc('dragon_raid').set({
      'slots_filled': 0,
      'max_slots': 15,
    });
  }
  
  runApp(
    ProviderScope(
      overrides: [
        firestoreProvider.overrideWithValue(firestore),
      ],
      child: const AetherApp(),
    ),
  );
}

class AetherApp extends StatelessWidget {
  const AetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Aether',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      home: const AetherHomeScreen(),
    );
  }
}

class AetherHomeScreen extends StatelessWidget {
  const AetherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROJECT AETHER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // @AETHER: Isolated 100ms rebuilds
            const BossTimerWidget(),
            const SizedBox(height: AppSpacing.large),
            
            // @AETHER: Atomic integrity raid signup
            const RaidSignupWidget(),
            const SizedBox(height: AppSpacing.large),
            
            const Text(
              'REAL-TIME CHAT',
              style: AppTextStyles.sectionLabel,
            ),
            const SizedBox(height: AppSpacing.small),
            
            // @AETHER: Scalable bounded chat
            const ChatWidget(),
          ],
        ),
      ),
    );
  }
}
