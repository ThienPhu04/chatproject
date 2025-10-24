part of 'onboarding_cubit.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}
class OnboardingLoading extends OnboardingState {}
class OnboardingFirstLaunch extends OnboardingState {}
class OnboardingCompleted extends OnboardingState {}