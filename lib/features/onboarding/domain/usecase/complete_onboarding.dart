import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call() => repository.completeOnboarding();
}