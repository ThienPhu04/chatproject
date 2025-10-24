abstract class OnboardingRepository {
  Future<bool> shouldShowWelcome();
  Future<void> completeOnboarding();
}