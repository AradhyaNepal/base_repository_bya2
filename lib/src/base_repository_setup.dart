import 'package:dio/dio.dart';

typedef StringReturnMethod = String Function();
typedef OnErrorHandleTokenExpiry = Function(DioException error);
typedef OnResponseInterceptor = Function(Response response);

class BaseRepositorySetup {
  //Todo: Make them private;
  static StringReturnMethod errorWithMobileOnApiRequest =
      () => "Unexpected Error With Mobile";
  static StringReturnMethod errorWithApiOnApiRequest =
      () => "Unexpected Error With API";
  static StringReturnMethod token = () => "";
  static OnErrorHandleTokenExpiry onErrorHandleTokenExpiry = (err) {
    if (err.response?.statusCode == 401) {
      //TODO: Might need to check other condition too, but after that Logout
    }
  };

  static OnResponseInterceptor onResponseInterceptor = (response) {

  };




  static void init({
    required StringReturnMethod errorWithMobileOnApiRequest,
    required StringReturnMethod errorWithApiOnApiRequest,
    required StringReturnMethod token,
    required OnErrorHandleTokenExpiry onErrorHandleTokenExpiry,
    required OnResponseInterceptor onResponseInterceptor,
  }) {
    BaseRepositorySetup.errorWithMobileOnApiRequest=errorWithMobileOnApiRequest;
    BaseRepositorySetup.errorWithApiOnApiRequest=errorWithApiOnApiRequest;
    BaseRepositorySetup.token=token;
    BaseRepositorySetup.onErrorHandleTokenExpiry=onErrorHandleTokenExpiry;
    BaseRepositorySetup.onResponseInterceptor=onResponseInterceptor;

  }
}
