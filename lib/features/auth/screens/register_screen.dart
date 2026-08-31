import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/core/utils/validators.dart';
import 'package:path_app/features/auth/widgets/auth_text_field.dart';
import 'package:path_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Registration flow ──

  Future<void> _handleRegister() async {
    // 1. Validate form fields.
    if (!_formKey.currentState!.validate()) return;

    // 2. Validate terms agreement.
    if (!_agreedToTerms) {
      _showErrorSnackBar('Please agree to the Terms of Service to continue.');
      return;
    }

    // 3. Clear any previous error.
    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    // 4. Call register.
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboardRoute);
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                      ),
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
        ),
      );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorScheme>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('PATH', style: theme.textTheme.bodyMedium),
        centerTitle: true,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Join the Journey',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start turning your goals into real progress.',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),

                  // ── Form Fields ──
                  AuthTextField(
                    label: 'Full Name',
                    hint: 'Jane Doe',
                    icon: Icons.person_outline,
                    controller: _nameController,
                    validator: Validators.validateName,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                  ),
                  AuthTextField(
                    label: 'Email Address',
                    hint: 'jane@example.com',
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
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  AuthTextField(
                    label: 'Confirm Password',
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleRegister(),
                    autofillHints: const [AutofillHints.newPassword],
                  ),

                  // ── Terms Checkbox ──
                  const SizedBox(height: 8),
                  _buildTermsCheckbox(colors),

                  // ── Submit Button ──
                  const SizedBox(height: 24),
                  _buildSubmitButton(),

                  // ── Login Link ──
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildLoginLink(colors),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(AppColorScheme colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) {
            setState(() {
              _agreedToTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: colors.primaryGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: colors.primaryGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoading = authProvider.status == AuthStatus.loading;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleRegister,
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
                        Text('Create Account'),
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

  Widget _buildLoginLink(AppColorScheme colors) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Log In',
              style: TextStyle(
                color: colors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigate back to onboarding for now (no login screen yet).
                  Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
