// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:path_app/core/router/app_router.dart';
// import 'package:path_app/features/auth/screens/login_screen.dart';
// import 'package:path_app/features/auth/screens/register_screen.dart';
// import 'package:path_app/features/onboarding/screens/onboarding_screen.dart';
// import 'package:path_app/providers/auth_provider.dart' ;
// import 'package:path_app/providers/theme_provider.dart';
// import 'package:path_app/providers/user_provider.dart';
// import 'package:path_app/services/firebase/auth_service.dart';
// import 'package:path_app/services/firebase/firestore_service.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Widget makeTestable(Widget child) {
//   final authService = AuthService();
//   final firestoreService = FirestoreService();

//   return EasyLocalization(
//     supportedLocales: const [Locale('en'), Locale('ar')],
//     path: 'assets/translations',
//     fallbackLocale: const Locale('en'),
//     child: MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(
//           create: (_) => AuthProvider(
//             authService: authService,
//             firestoreService: firestoreService,
//           ),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => UserProvider(firestoreService: firestoreService),
//         ),
//       ],
//       child: MaterialApp(home: child, onGenerateRoute: AppRouter.generateRoute),
//     ),
//   );
// }

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() async {
//     SharedPreferences.setMockInitialValues({});
//     await EasyLocalization.ensureInitialized();
//   });

//   group('auth and onboarding route integrity', () {
//     test('register and login screen route names match router constants', () {
//       expect(RegisterScreen.routeName, AppRouter.registerRoute);
//       expect(LoginScreen.routeName, AppRouter.loginRoute);
//     });

//     test('router exposes valid auth routes', () {
//       final loginRoute = AppRouter.generateRoute(
//         const RouteSettings(name: AppRouter.loginRoute),
//       );
//       final registerRoute = AppRouter.generateRoute(
//         const RouteSettings(name: AppRouter.registerRoute),
//       );

//       expect(loginRoute, isA<MaterialPageRoute>());
//       expect(registerRoute, isA<MaterialPageRoute>());
//     });

//     testWidgets('onboarding screen renders its primary call-to-action', (
//       tester,
//     ) async {
//       await tester.pumpWidget(makeTestable(const OnboardingScreen()));
//       await tester.pump();

//       expect(find.byType(ElevatedButton), findsOneWidget);
//     });

//     testWidgets('login screen restores remembered credentials', (tester) async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('remember_me', true);
//       await prefs.setString('remembered_email', 'saved@example.com');
//       await prefs.setString('remembered_password', 'Password123');

//       await tester.pumpWidget(makeTestable(const LoginScreen()));
//       await tester.pump();

//       final textFields = tester.widgetList<TextFormField>(
//         find.byType(TextFormField),
//       );
//       final emailField = textFields.elementAt(0);
//       final passwordField = textFields.elementAt(1);

//       expect(emailField.controller?.text, 'saved@example.com');
//       expect(passwordField.controller?.text, 'Password123');

//       final rememberCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
//       expect(rememberCheckbox.value, isTrue);
//     });
//   });
// }
