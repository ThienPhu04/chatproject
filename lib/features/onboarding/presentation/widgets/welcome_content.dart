import 'package:finalproject/core/theme/themecolor.dart';
import 'package:finalproject/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WelcomeContent extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeContent({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 79),
          const Text(
            "You AI Assistant",
            style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700, color: ThemeColor.titleWelcome)
          ),
          const SizedBox(height: 16),
          Container(
            constraints: BoxConstraints(
              maxWidth: 250,
              minWidth: 200,
            ),
            alignment: Alignment.center,
            child: Text(
              "Using this software,you can ask you questions and receive articles using artificial intelligence assistant",
              textAlign: TextAlign.center,style: TextStyle(color: ThemeColor.contetxWelcome,fontSize: 15,fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 320,
            height: 324,
            child: Image.asset('assets/images/welcome.png'),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<OnboardingCubit>().finishOnboarding();
              context.go('/chat');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.titleWelcome,
            ),
            child: const Text(
              "Continue",
              style: TextStyle(color: ThemeColor.buttontitleWelcome),
            ),
          )

        ],
      ),
    );
  }
}
