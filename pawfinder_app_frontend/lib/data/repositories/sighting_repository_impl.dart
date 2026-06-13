import 'package:dartz/dartz.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/sighting_model.dart';
import '../../domain/entities/sighting.dart';
import '../../domain/repositories/sighting_repository.dart';

/// Real API implementation of [SightingRepository].
class SightingRepositoryImpl implements SightingRepository {
  final ApiClient _client;

  SightingRepositoryImpl({required ApiClient client}) : _client = client;

  @override
  Future<Either<Failure, Sighting>> reportSighting({
    required String alertId,
    required String finderId,
    required double lat,
    required double lng,
    List<String> photoUrls = const [],
    String? notes,
  }) async {
    try {
      final json = await _client.post(ApiConstants.sightings, data: {
        'alertId': alertId,
        'finderId': finderId,
        'lat': lat,
        'lng': lng,
        'photoUrls': photoUrls,
        if (notes != null) 'notes': notes,
      });
      final sighting =
          SightingModel.fromJson(json as Map<String, dynamic>).toEntity();
      return Right(sighting);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Sighting>>> getSightingsForAlert(
    String alertId,
  ) async {
    try {
      final json = await _client.get(ApiConstants.sightings,
          queryParameters: {'alertId': alertId});
      final list = (json as List<dynamic>)
          .map((e) =>
              SightingModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Sighting>> confirmSighting(
    String sightingId,
  ) async {
    try {
      final json =
          await _client.put('${ApiConstants.sightings}/$sightingId/confirm');
      final sighting =
          SightingModel.fromJson(json as Map<String, dynamic>).toEntity();
      return Right(sighting);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Sighting>> rejectSighting(String sightingId) async {
    try {
      final json =
          await _client.put('${ApiConstants.sightings}/$sightingId/reject');
      final sighting =
          SightingModel.fromJson(json as Map<String, dynamic>).toEntity();
      return Right(sighting);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
