import 'package:finalproject/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/welcome_content.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OnboardingFirstLaunch) {
          return Scaffold(
            body: WelcomeContent(
              onGetStarted: () {
                context.read<OnboardingCubit>().finishOnboarding();
                context.go("/chat");
              },
            ),
          );
        }
        if (state is OnboardingCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go("/chat");
          });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
