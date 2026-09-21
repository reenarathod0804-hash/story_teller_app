import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/core/presentation/screen/select/screen1.dart';
import 'package:story_teller/features/home/presentation/data/model/authProvider.dart'
    as app_auth;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<app_auth.AuthProvider>(
        builder: (context, authProvider, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.08),
                  // Illustration / Logo
                  Center(
                    child: Container(
                      height: size.height * 0.28,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: AppColors.mainBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 110,
                        color: AppColors.mainBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  // Title
                  Text(
                    'Welcome to Story Teller',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Carlito Bold',
                      fontSize: 28,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: size.height * 0.012),
                  Text(
                    'Sign in to explore magical stories\nfor kids around the world.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Carlito Regular',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),

                  // Error message
                  if (authProvider.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authProvider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontFamily: 'Carlito Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],

                  // Google Sign-In button
                  authProvider.isLoading
                      ? SizedBox(
                          height: size.height * 0.065,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainBlue,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: size.height * 0.065,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final success =
                                  await authProvider.signInWithGoogle();
                              if (success && context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectScreen1()),
                                );
                              }
                            },
                            icon: Image.asset(
                              'assets/images/png/google_logo.png',
                              height: 24,
                              width: 24,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.g_mobiledata_rounded,
                                size: 28,
                                color: AppColors.mainBlue,
                              ),
                            ),
                            label: Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontFamily: 'Carlito Bold',
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Colors.grey.shade300, width: 1.2),
                              ),
                            ),
                          ),
                        ),

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'By signing in, you agree to our Terms of Service\nand Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Carlito Regular',
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
