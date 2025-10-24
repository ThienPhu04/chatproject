import 'package:easy_localization/easy_localization.dart';
import 'package:finalproject/core/constant/constant.dart';
import 'package:finalproject/core/theme/themecolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../gen/assets.gen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widget/custom_text_field.dart';
import '../widget/social_login_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go("/chat");
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // App Logo
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Assets.images.logo.image(
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome Text
                    Text(
                      AppTitle.createAccount.tr(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Name TextField
                    CustomTextField(
                      controller: _nameController,
                      hintText: AppTitle.fullName.tr(),
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTitle.enterYourname.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email TextField
                    CustomTextField(
                      controller: _emailController,
                      hintText: AppTitle.email.tr(),
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTitle.enterEmail.tr();
                        }
                        if (!value.contains('@')) {
                          return AppTitle.enterValidEmail.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password TextField
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppTitle.password.tr(),
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTitle.enterPassword.tr();
                        }
                        if (value.length < 6) {
                          return AppTitle.enterLessPass.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password TextField
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: AppTitle.confirmPassword.tr(),
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTitle.confirmYourPass.tr();
                        }
                        if (value != _passwordController.text) {
                          return AppTitle.passnotMatch.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Register Button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().registerWithEmail(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.buttonWelcome,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            AppTitle.signUp.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppTitle.continueText.tr(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          color: Colors.red,
                          onPressed: () {
                            context.read<AuthCubit>().loginWithGoogle();
                          },
                        ),
                        const SizedBox(width: 16),
                        SocialLoginButton(
                          icon: Icons.facebook,
                          color: Colors.blue[800]!,
                          onPressed: () {
                            context.read<AuthCubit>().loginWithFacebook();
                          },
                        ),
                        const SizedBox(width: 16),
                        SocialLoginButton(
                          icon: Icons.apple,
                          color: Colors.black,
                          onPressed: () {
                            context.read<AuthCubit>().loginWithApple();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTitle.haveAccount.tr(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthCubit>().resetState();
                            context.go("/login");
                          },
                          child: Text(
                            AppTitle.login.tr(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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