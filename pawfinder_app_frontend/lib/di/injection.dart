import 'package:get_it/get_it.dart';
import 'package:pawfinder_app/data/datasources/remote/api_client.dart';
import 'package:pawfinder_app/data/repositories/alert_repository_impl.dart';
import 'package:pawfinder_app/data/repositories/auth_repository_impl.dart';
import 'package:pawfinder_app/data/repositories/conversation_repository_impl.dart';
import 'package:pawfinder_app/data/repositories/pet_repository_impl.dart';
import 'package:pawfinder_app/data/repositories/sighting_repository_impl.dart';
import 'package:pawfinder_app/domain/repositories/alert_repository.dart';
import 'package:pawfinder_app/domain/repositories/auth_repository.dart';
import 'package:pawfinder_app/domain/repositories/conversation_repository.dart';
import 'package:pawfinder_app/domain/repositories/pet_repository.dart';
import 'package:pawfinder_app/domain/repositories/sighting_repository.dart';
import 'package:pawfinder_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:pawfinder_app/services/analytics_service.dart';
import 'package:pawfinder_app/services/auth_service.dart';
import 'package:pawfinder_app/services/location_service.dart';
import 'package:pawfinder_app/services/notification_service.dart';
import 'package:pawfinder_app/services/websocket_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  final authService = AuthService();
  await authService.initialize();
  getIt.registerLazySingleton<AuthService>(() => authService);

  getIt.registerLazySingleton<LocationService>(() => LocationService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<WebSocketService>(
    () => WebSocketService(authService: getIt<AuthService>()),
  );

  // Data sources
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(authService: getIt<AuthService>()),
  );

  // Repositories — API-backed implementations
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: getIt<ApiClient>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerLazySingleton<AlertRepository>(
    () => AlertRepositoryImpl(client: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<SightingRepository>(
    () => SightingRepositoryImpl(client: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(client: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(client: getIt<ApiClient>()),
  );

  // Blocs / Cubits
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
      authService: getIt<AuthService>(),
    ),
  );
}
