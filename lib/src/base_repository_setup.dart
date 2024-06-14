import 'package:dio/dio.dart';

typedef StringReturnMethod = String Function();
typedef OnErrorHandleTokenExpiry = Function(DioException error);
typedef OnResponseInterceptor = Function(Response response);
typedef ErrorMapper = String? Function(dynamic response);

class BaseRepositorySetup {
  static StringReturnMethod _errorWithMobileOnApiRequest =
      () => "Unexpected Error With Mobile";

  static StringReturnMethod get errorWithMobileOnApiRequest =>
      _errorWithMobileOnApiRequest;
  static StringReturnMethod _errorWithApiOnApiRequest =
      () => "Unexpected Error With API";

  static StringReturnMethod get errorWithApiOnApiRequest =>
      _errorWithApiOnApiRequest;
  static StringReturnMethod _tokenMapper = () => "";

  static StringReturnMethod get tokenMapper => _tokenMapper;
  static OnErrorHandleTokenExpiry _onErrorHandleTokenExpiry = (err) {
    if (err.response?.statusCode == 401) {
      //TODO: Might need to check other condition too, but after that Logout
    }
  };

  static OnErrorHandleTokenExpiry get onErrorHandleTokenExpiry =>
      _onErrorHandleTokenExpiry;

  static OnResponseInterceptor _onResponseInterceptor = (response) {};

  static OnResponseInterceptor get onResponseInterceptor =>
      _onResponseInterceptor;

  static ErrorMapper _onErrorMapper = (response) {
    return response["message"];
  };

  static ErrorMapper get onErrorMapper => _onErrorMapper;

  static void init({
    required StringReturnMethod errorWithMobileOnApiRequest,
    required StringReturnMethod errorWithApiOnApiRequest,
    required StringReturnMethod tokenMapper,
    required OnErrorHandleTokenExpiry onErrorHandleTokenExpiry,
    required OnResponseInterceptor onResponseInterceptor,
    required ErrorMapper onErrorMapper,
  }) {
    BaseRepositorySetup._errorWithMobileOnApiRequest =
        errorWithMobileOnApiRequest;
    BaseRepositorySetup._errorWithApiOnApiRequest = errorWithApiOnApiRequest;
    BaseRepositorySetup._tokenMapper = tokenMapper;
    BaseRepositorySetup._onErrorHandleTokenExpiry = onErrorHandleTokenExpiry;
    BaseRepositorySetup._onResponseInterceptor = onResponseInterceptor;
    BaseRepositorySetup._onErrorMapper = onErrorMapper;
  }
}
