import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_app/app.dart';
import 'package:path_app/providers/auth_provider.dart';
import 'package:path_app/providers/goal_draft_provider.dart';
import 'package:path_app/providers/goal_provider.dart';
import 'package:path_app/providers/theme_provider.dart';
import 'package:path_app/providers/user_provider.dart';
import 'package:path_app/services/firebase/auth_service.dart';
import 'package:path_app/services/firebase/firestore_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  // Instantiate services once — shared across providers.
  final authService = AuthService();
  final firestoreService = FirestoreService();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => GoalProvider()),
          ChangeNotifierProvider(create: (_) => GoalDraftProvider()),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              authService: authService,
              firestoreService: firestoreService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => UserProvider(firestoreService: firestoreService),
          ),
        ],
        child: const PathApp(),
      ),
    ),
  );
}
