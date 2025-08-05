import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/sign_up_prompt_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometric = false;
  final ScrollController _scrollController = ScrollController();

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@habitflow.com': 'admin123',
    'user@habitflow.com': 'user123',
    'demo@habitflow.com': 'demo123',
  };

  @override
  void initState() {
    super.initState();
    _checkForStoredCredentials();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkForStoredCredentials() {
    // Simulate checking for stored credentials
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showBiometric = true;
        });
      }
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase()) &&
          _mockCredentials[email.toLowerCase()] == password) {
        // Success - provide haptic feedback
        HapticFeedback.lightImpact();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.onTertiary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text('Login successful! Welcome back.'),
                ],
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate to main dashboard
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/main-dashboard');
          }
        }
      } else {
        // Invalid credentials
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error',
                    color: AppTheme.lightTheme.colorScheme.onError,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text('Invalid email or password. Please try again.'),
                  ),
                ],
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: AppTheme.lightTheme.colorScheme.onError,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Network or other error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'wifi_off',
                  color: AppTheme.lightTheme.colorScheme.onError,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                      'Network error. Please check your connection and try again.'),
                ),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: AppTheme.lightTheme.colorScheme.onError,
              onPressed: () => _handleLogin(email, password),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricSuccess() {
    // Simulate successful biometric authentication
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo
                    const AppLogoWidget(),

                    SizedBox(height: 2.h),

                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to continue your wellness journey',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    // Biometric Authentication
                    BiometricAuthWidget(
                      onBiometricSuccess: _handleBiometricSuccess,
                      isVisible: _showBiometric && !_isLoading,
                    ),

                    // Sign Up Prompt
                    const SignUpPromptWidget(),

                    SizedBox(height: 2.h),

                    // Demo Credentials Info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Demo Credentials',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'admin@habitflow.com / admin123\nuser@habitflow.com / user123\ndemo@habitflow.com / demo123',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontFamily: 'monospace',
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
