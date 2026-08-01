import 'package:get_it/get_it.dart';
import '../../services/program_service.dart';
import '../../notifiers/feedback_notifier.dart';
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Registers ProgramService as a Lazy Singleton:
  // It only initializes when requested for the first time, and then keeps
  // that single instance alive for the rest of the app lifetime.
  getIt.registerLazySingleton<ProgramService>(() => ProgramService());
  getIt.registerLazySingleton<FeedbackNotifier>(() => FeedbackNotifier());
}