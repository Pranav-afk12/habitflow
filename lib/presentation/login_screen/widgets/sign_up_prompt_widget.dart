import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SignUpPromptWidget extends StatelessWidget {
  const SignUpPromptWidget({Key? key}) : super(key: key);

  void _handleSignUpTap(BuildContext context) {
    // Navigate to sign up screen (placeholder for now)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text('Sign up feature coming soon'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
          ),
          GestureDetector(
            onTap: () => _handleSignUpTap(context),
            child: Text(
              'Sign Up',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
