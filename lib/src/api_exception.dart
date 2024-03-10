import 'dart:developer';

import 'package:dio/dio.dart';
import 'base_repository_setup.dart';

class CustomAPIException implements Exception {
  String errorMessage;

  int get statusCode => response?.statusCode ?? -1;
  Object? originalErrorObject;
  StackTrace? stackTrace;
  Response? response;

  CustomAPIException(
    this.errorMessage,
    this.response, {
    this.originalErrorObject,
    this.stackTrace,
  });

  @override
  String toString() {
    return errorMessage;
  }

  factory CustomAPIException.onParsing(Object e, StackTrace s) {
    log(e.toString());
    log(s.toString());
    return CustomAPIException(
      BaseRepositorySetup.errorWithMobileOnApiRequest(),
      null,
    );
  }

  factory CustomAPIException.onCatch(Object e, StackTrace s) {
    if (e is DioException) {

      final errorMessage = e.response?.data?["message"];
      if (errorMessage != null) {
        return CustomAPIException(
          errorMessage,
          e.response,
          originalErrorObject: e,
          stackTrace: s,
        );
      }
      log(e.toString());
      log(s.toString());
      return CustomAPIException(
        BaseRepositorySetup.errorWithApiOnApiRequest(),
        e.response,
        originalErrorObject: e,
        stackTrace: s,
      );
    } else {
      log(e.toString());
      log(s.toString());
      return CustomAPIException(
        BaseRepositorySetup.errorWithMobileOnApiRequest(),
        null,
        originalErrorObject: e,
        stackTrace: s,
      );
    }
  }
}
