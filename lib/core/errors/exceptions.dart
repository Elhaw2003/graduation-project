import 'package:dio/dio.dart';
import 'package:smart_guide/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  ServerException({required this.errModel});
}

/// Helper function to parse error response (handles both String and Map responses)
ErrorModel parseErrorResponse(dynamic data, int statusCode) {
  // If data is null or empty
  if (data == null) {
    return ErrorModel(
      statusCode: statusCode,
      message: getDefaultErrorMessage(statusCode),
      generalErrors: [getDefaultErrorMessage(statusCode)],
    );
  }

  // If data is a String
  if (data is String) {
    return ErrorModel(
      statusCode: statusCode,
      message: data.isEmpty ? getDefaultErrorMessage(statusCode) : data,
      generalErrors: [
        data.isEmpty ? getDefaultErrorMessage(statusCode) : data,
      ],
    );
  }

  // If data is a Map
  if (data is Map<String, dynamic>) {
    return ErrorModel.fromJson(data);
  }

  // Fallback for unexpected types
  return ErrorModel(
    statusCode: statusCode,
    message: getDefaultErrorMessage(statusCode),
    generalErrors: [getDefaultErrorMessage(statusCode)],
  );
}

/// Get default error message based on status code
String getDefaultErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request. Please check your input.';
    case 401:
      return 'Unauthorized. Please login again.';
    case 403:
      return 'Access forbidden.';
    case 404:
      return 'Resource not found.';
    case 409:
      return 'Conflict occurred.';
    case 422:
      return 'Unprocessable entity.';
    case 500:
      return 'Internal server error.';
    case 504:
      return 'Server timeout.';
    default:
      return 'An error occurred. Please try again.';
  }
}

void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Connection timeout. Please check your internet connection.',
          generalErrors: [
            'Connection timeout. Please check your internet connection.',
          ],
        ),
      );
    case DioExceptionType.sendTimeout:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Send timeout. Please try again.',
          generalErrors: ['Send timeout. Please try again.'],
        ),
      );
    case DioExceptionType.receiveTimeout:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Receive timeout. Please try again.',
          generalErrors: ['Receive timeout. Please try again.'],
        ),
      );
    case DioExceptionType.badCertificate:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Bad certificate. Connection is not secure.',
          generalErrors: ['Bad certificate. Connection is not secure.'],
        ),
      );
    case DioExceptionType.cancel:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Request cancelled.',
          generalErrors: ['Request cancelled.'],
        ),
      );
    case DioExceptionType.connectionError:
      throw ServerException(
        errModel: ErrorModel(
          statusCode: 0,
          message: 'Connection error. Please check your internet connection.',
          generalErrors: [
            'Connection error. Please check your internet connection.',
          ],
        ),
      );
    case DioExceptionType.unknown:
      throw ServerException(
        errModel: parseErrorResponse(
          e.response?.data,
          e.response?.statusCode ?? 0,
        ),
      );
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 400),
          );
        case 401: //unauthorized
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 401),
          );
        case 403: //forbidden
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 403),
          );
        case 404: //not found
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 404),
          );
        case 409: //conflict
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 409),
          );
        case 422: //  Unprocessable Entity
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 422),
          );
        case 500: // Internal server error
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 500),
          );
        case 504: // Server timeout
          throw ServerException(
            errModel: parseErrorResponse(e.response?.data, 504),
          );
        default:
          throw ServerException(
            errModel: parseErrorResponse(
              e.response?.data,
              e.response?.statusCode ?? 0,
            ),
          );
      }
  }
}
