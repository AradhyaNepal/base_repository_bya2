import 'package:dio/dio.dart';

import 'repository_details.dart';

class RequestInput<T> {
  String url;
  Object? body;
  Map? header;
  Map<String, dynamic>? params;
  RepositoryDetails? repositoryDetails;
  CancelToken? cancelToken;
  ResponseType? responseType;
  T Function(dynamic map) parseJson;
  bool isList;

  RequestInput({
    required this.url,
    required this.parseJson,
    this.body,
    this.header,
    this.params,
    this.repositoryDetails,
    this.cancelToken,
    this.responseType,
    this.isList=false,
  });
}
