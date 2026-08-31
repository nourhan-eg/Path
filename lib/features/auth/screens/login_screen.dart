import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/constants/app_images.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/core/utils/validators.dart';
import 'package:path_app/features/auth/widgets/auth_text_field.dart';
import 'package:path_app/providers/auth_provider.dart' as app_auth;
import 'package:path_app/services/firebase/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = AppRouter.loginRoute;
  static const String rememberMeKey = 'remember_me';
  static const String rememberedEmailKey = 'remembered_email';
  static const String rememberedPasswordKey = 'remembered_password';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  late final AnimationController _iconAnimController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _loadRememberedCredentials();

    // Clear any stale auth errors when entering the screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<app_auth.AuthProvider>().clearError();
    });

    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Gentle pulse: scale 1.0 → 1.06 → 1.0
    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _iconAnimController, curve: Curves.easeInOut),
        );

    // Subtle rotation: 0 → -8° → 0 → 8° → 0
    _rotateAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.10), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.10, end: 0.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.10), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.10, end: 0.0), weight: 25),
        ]).animate(
          CurvedAnimation(parent: _iconAnimController, curve: Curves.easeInOut),
        );

    _iconAnimController.repeat();
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldRemember = prefs.getBool(LoginScreen.rememberMeKey) ?? false;
    final savedEmail = prefs.getString(LoginScreen.rememberedEmailKey) ?? '';
    final savedPassword =
        prefs.getString(LoginScreen.rememberedPasswordKey) ?? '';

    if (!mounted) return;

    setState(() {
      _rememberMe = shouldRemember;
      if (shouldRemember) {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      }
    });
  }

  Future<void> _persistRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(LoginScreen.rememberMeKey, _rememberMe);

    if (_rememberMe) {
      await prefs.setString(
        LoginScreen.rememberedEmailKey,
        _emailController.text.trim(),
      );
      await prefs.setString(
        LoginScreen.rememberedPasswordKey,
        _passwordController.text,
      );
    } else {
      await prefs.remove(LoginScreen.rememberedEmailKey);
      await prefs.remove(LoginScreen.rememberedPasswordKey);
    }
  }

  // ── Login flow ──

  Future<void> _handleLogin() async {
    // 1. Validate form fields (client-side).
    if (!_formKey.currentState!.validate()) return;

    // 2. Clear previous errors.
    final authProvider = context.read<app_auth.AuthProvider>();
    authProvider.clearError();

    // 3. Attempt login.
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // 4. Handle result.
    if (success) {
      await _persistRememberMeState();
      // Navigate and prevent back-button to login.
      Navigator.pushReplacementNamed(context, AppRouter.dashboardNoGoalRoute);
    } else if (authProvider.errorMessage != null) {
      _showErrorSnackBar(authProvider.errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: colors.error, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: colors.card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.error.withValues(alpha: 0.3)),
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: colors.error,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
  }

  void _showSuccessSnackBar(String message) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: colors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: colors.card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.primaryGreen.withValues(alpha: 0.2)),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorScheme>() ?? AppColorScheme.light;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  // ── Animated Star Icon ──
                  _buildAnimatedIcon(),
                  const SizedBox(height: 28),

                  // ── Heading ──
                  Text('Welcome Back', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Continue your journey to mastery.',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 36),

                  // ── Form Fields ──
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                  AuthTextField(
                    label: 'Password',
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    obscureText: true,
                    validator: _validateLoginPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    autofillHints: const [AutofillHints.password],
                  ),

                  // ── Remember Me / Forgot Password ──
                  _buildRememberForgotRow(colors),
                  const SizedBox(height: 32),

                  // ── Login Button ──
                  _buildLoginButton(),
                  const SizedBox(height: 28),

                  // ── Sign Up Link ──
                  _buildSignUpLink(colors),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Login password validator — less strict than registration.
  /// Only checks that the field is non-empty (Firebase will validate the rest).
  String? _validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Star image icon with pulse + rotation animation.
  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _iconAnimController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(angle: _rotateAnimation.value, child: child),
        );
      },
      child: ClipOval(
        child: Image.asset(
          AppImages.loginIcon,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow(AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me
        GestureDetector(
          onTap: () async {
            setState(() {
              _rememberMe = !_rememberMe;
            });
            await _persistRememberMeState();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) async {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                    await _persistRememberMeState();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Forgot Password
        GestureDetector(
          onTap: _handleForgotPassword,
          child: Text(
            'Forgot Password?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }

  void _handleForgotPassword() {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    final resetEmailController = TextEditingController();
    final resetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email and we\'ll send you a link to reset your password.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!resetFormKey.currentState!.validate()) return;

                      final email = resetEmailController.text.trim();

                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(ctx);
                        _showSuccessSnackBar(
                          'A password reset link was sent to $email.',
                        );
                      } on FirebaseAuthException catch (e) {
                        if (!context.mounted) return;
                        Navigator.pop(ctx);
                        _showErrorSnackBar(AuthService.mapFirebaseAuthError(e));
                      } catch (_) {
                        if (!context.mounted) return;
                        Navigator.pop(ctx);
                        _showErrorSnackBar(
                          'Something went wrong while sending the reset link.',
                        );
                      }
                    },
                    child: const Text('Send Reset Link'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<app_auth.AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoading = authProvider.status == app_auth.AuthStatus.loading;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      key: ValueKey('idle'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Log In'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink(AppColorScheme colors) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: colors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.registerRoute,
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
