import 'dart:developer';

import 'package:dio/dio.dart';

import '../base_repository_bya2.dart';

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
    BaseRepositorySetup.onParsingException(e, s);
    if (e is CustomAPIException) {
      return e;
    } else {
      final value = CustomAPIException(
        BaseRepositorySetup.errorWithMobileOnApiRequest(),
        null,
      );

      return value;
    }
  }

  factory CustomAPIException.onCatch(Object e, StackTrace s) {
    try {
      if (e is CustomAPIException) {
        return e;
      } else if (e is DioException) {
        final errorMessage =
            BaseRepositorySetup.onErrorMapper(e.response?.data);
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
    } catch (e, s) {
      return CustomAPIException.onParsing(e, s);
    }
  }
}
