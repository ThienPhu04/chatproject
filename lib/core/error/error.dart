/// Base class cho tất cả các lỗi trong ứng dụng
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NotFoundException extends Failure {
  const NotFoundException(super.message);
}

class Result<T> {
  final T? data;
  final Failure? error;

  const Result._({this.data, this.error});

  factory Result.success(T data) {
    return Result._(data: data);
  }

  factory Result.failure(Failure error) {
    return Result._(error: error);
  }

  bool get isSuccess => data != null && error == null;

  bool get isFailure => error != null;

  /// Pattern matching như fold trong Either
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else {
      return failure(error!);
    }
  }
}

/// Generic Repository base với type safety
/// T: Entity type (domain layer)
/// M: Model type (data layer)
abstract class BaseRepository<T, M> {
  /// Convert Model sang Entity
  T modelToEntity(M model);

  /// Convert Entity sang Model
  M entityToModel(T entity);

  /// Generic method để xử lý lỗi thống nhất
  Future<Result<R>> handleRequest<R>(
      Future<R> Function() request,
      ) async {
    try {
      final result = await request();
      return Result.success(result);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Generic method để convert list models sang entities
  List<T> modelsToEntities(List<M> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }

  /// Generic method để convert list entities sang models
  List<M> entitiesToModels(List<T> entities) {
    return entities.map((entity) => entityToModel(entity)).toList();
  }

  T? modelToEntityNullable(M? model) {
    if (model == null) return null;
    return modelToEntity(model);
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}