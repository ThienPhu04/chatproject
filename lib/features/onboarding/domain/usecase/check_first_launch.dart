import '../repositories/onboarding_repository.dart';

class CheckFirstLaunch {
  final OnboardingRepository repository;

  CheckFirstLaunch(this.repository);

  Future<bool> call() => repository.shouldShowWelcome();
}