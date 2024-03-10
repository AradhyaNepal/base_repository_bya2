import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'repository_details.dart';
import 'app_interceptor.dart';
import 'request_input.dart';
import 'api_exception.dart';
import 'base_repository_setup.dart';

class BaseRepository {
  final Dio _client;

  static Dio get staticDio => Dio();

  Dio get dio => _client;
  final RepositoryDetails _globalRepositoryDetails;

  ///If on a specific request, [RepositoryDetails] are not passed,
  ///then this [globalRepositoryDetails] is used.
  RepositoryDetails get globalRepositoryDetails => _globalRepositoryDetails;

  ///In order to do the testing, you can pass Mocked Dio on [dio].
  ///
  /// For Security purpose, the logs of the network dio request will only will
  /// displayed on debug and profile mode, those logs will on work on release.
  BaseRepository({
    Dio? dio,
    RepositoryDetails? repositoryDetails,
  })  : _client = dio ?? Dio(),
        _globalRepositoryDetails = repositoryDetails ?? RepositoryDetails() {
    _client.interceptors.add(AppInterceptor());
    if (!kReleaseMode) {
      //Unlike tokenExpired interceptor, Log interception must not be shown on release mode.
      //Because it might expose user sensitive details like there Token, or even
      //our developer's internal data.
      _client.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
        ),
      );
    }
  }

  Future<T> get<T>(
    RequestInput<T> input,
  ) async {
    try {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);
      final response = await _client
          .get(
            input.url,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      final outputJson = repositoryDetails.responseManipulate(response.data);
      return input.parseJson(outputJson);
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  Future<T> post<T>(RequestInput<T> input, {bool isMultipart = false}) async {
    try {
      log(input.body.toString(), name: 'inout daraa');
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded,
          isMultipart: isMultipart);
      final response = await _client
          .post(
            input.url,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      final outputJson = repositoryDetails.responseManipulate(response.data);
      return input.parseJson(outputJson);
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  Future<T> delete<T>(
    RequestInput<T> input,
  ) async {
    try {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);
      final response = await _client
          .delete(
            input.url,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      final outputJson = repositoryDetails.responseManipulate(response.data);
      return input.parseJson(outputJson);
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  Future<T> put<T>(
    RequestInput<T> input,
  ) async {
    try {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);
      final response = await _client
          .put(
            input.url,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      final outputJson = repositoryDetails.responseManipulate(response.data);
      return input.parseJson(outputJson);
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  Future<T> patch<T>(
    RequestInput<T> input,
  ) async {
    try {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);
      final response = await _client
          .patch(
            input.url,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      return _parseAndReturn(repositoryDetails, response, input);
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  dynamic _parseAndReturn(
    RepositoryDetails repositoryDetails,
    Response<dynamic> response,
    RequestInput<dynamic> input,
  ) {
    try {
      final outputJson = repositoryDetails.responseManipulate(response.data);
      return input.parseJson(outputJson);
    } catch (e, s) {
      throw CustomAPIException.onParsing(e, s);
    }
  }

  Future<dynamic> download(RequestInput input, String savePath) async {
    try {
      final repositoryDetails =
          input.repositoryDetails ?? _globalRepositoryDetails;
      final heading = await _getHeading(repositoryDetails.tokenNeeded);

      final response = await _client
          .download(
            input.url,
            savePath,
            data: input.body,
            queryParameters: input.params,
            cancelToken: input.cancelToken,
            options: Options(
              headers: {
                ...heading,
                ...?input.header,
              },
              responseType: input.responseType,
            ),
          )
          .timeout(Duration(seconds: repositoryDetails.requestTimeout));
      return response.data;
    } catch (e, s) {
      throw CustomAPIException.onCatch(e, s);
    }
  }

  Future<Map<String, String>> _getHeading(bool needToken,
      {bool isMultipart = false}) async {
    return {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      if (needToken) 'Authorization': 'Bearer ${BaseRepositorySetup.token()}',
      if (isMultipart) 'Content-Type': 'multipart/form-data'
    };
  }
}
