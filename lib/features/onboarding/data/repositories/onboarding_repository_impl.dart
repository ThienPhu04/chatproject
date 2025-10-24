import '../datasources/onboarding_local_data_source.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<bool> shouldShowWelcome() => localDataSource.isFirstLaunch();

  @override
  Future<void> completeOnboarding() => localDataSource.completeOnboarding();
}
