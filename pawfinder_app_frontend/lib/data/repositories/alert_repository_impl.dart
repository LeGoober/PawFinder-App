import 'package:dartz/dartz.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/alert_model.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';

/// Real API implementation of [AlertRepository].
class AlertRepositoryImpl implements AlertRepository {
  final ApiClient _client;

  AlertRepositoryImpl({required ApiClient client}) : _client = client;

  @override
  Future<Either<Failure, Alert>> createAlert({
    required String petId,
    required double lat,
    required double lng,
    required String lastSeenAddress,
    String? description,
    double rewardAmount = 0,
    String rewardCurrency = 'ZAR',
    double geofenceRadiusKm = 2.0,
  }) async {
    try {
      final json = await _client.post(ApiConstants.alerts, data: {
        'petId': petId,
        'lastSeenLat': lat,
        'lastSeenLng': lng,
        'lastSeenAddress': lastSeenAddress,
        if (description != null) 'description': description,
        'rewardAmount': rewardAmount,
        'rewardCurrency': rewardCurrency,
        'geofenceRadiusKm': geofenceRadiusKm,
      });
      final alert = AlertModel.fromJson(json as Map<String, dynamic>);
      return Right(alert.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Alert>>> getNearbyAlerts({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      final json = await _client.get(ApiConstants.alertsNearby, queryParameters: {
        'lat': lat.toString(),
        'lng': lng.toString(),
        'radiusKm': radiusKm.toString(),
      });
      final list = (json as List<dynamic>)
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Alert>> getAlertById(String id) async {
    try {
      final json = await _client.get(ApiConstants.alertById(id));
      final alert = AlertModel.fromJson(json as Map<String, dynamic>);
      return Right(alert.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Alert>> resolveAlert(String id) async {
    try {
      final json = await _client.put('${ApiConstants.alertById(id)}/resolve');
      final alert = AlertModel.fromJson(json as Map<String, dynamic>);
      return Right(alert.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Alert>> cancelAlert(String id) async {
    try {
      final json = await _client.put('${ApiConstants.alertById(id)}/cancel');
      final alert = AlertModel.fromJson(json as Map<String, dynamic>);
      return Right(alert.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
