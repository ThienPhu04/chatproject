import 'package:bloc/bloc.dart';
import '../../domain/usecase/check_first_launch.dart';
import '../../domain/usecase/complete_onboarding.dart';
part "onboarding_state.dart";

class OnboardingCubit extends Cubit<OnboardingState> {
  final CheckFirstLaunch checkFirstLaunch;
  final CompleteOnboarding completeOnboarding;

  OnboardingCubit({
    required this.checkFirstLaunch,
    required this.completeOnboarding,
  }) : super(OnboardingInitial());

  Future<void> loadOnboarding() async {
    emit(OnboardingLoading());
    final isFirst = await checkFirstLaunch();
    if (isFirst) {
      emit(OnboardingFirstLaunch());
    } else {
      emit(OnboardingCompleted());
    }
  }

  Future<void> finishOnboarding() async {
    await completeOnboarding();
    emit(OnboardingCompleted());
  }
}