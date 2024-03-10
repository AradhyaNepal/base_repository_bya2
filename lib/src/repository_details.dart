import 'dart:developer';

import 'typedef.dart';

class RepositoryDetails {
  final bool _tokenNeeded;

  ///Defaults to true,
  ///If this is set true, token is passed in all of the request
  bool get tokenNeeded => _tokenNeeded;
  
  final int _requestTimeout;

  ///On Dio request, its the duration after which the repo hits the timeout
  ///which is measured in seconds
  ///
  ///If nothing is set, then its 60 seconds
  int get requestTimeout => _requestTimeout;

  final ResponseManipulator _responseManipulate;

  ///In most case backend return a generic response,
  ///like:
  ///
  /// {
  ///
  ///   ...
  ///
  ///   "data":{
  ///       ... Actual Result that we need
  ///   }
  ///
  /// }
  ///
  /// This method is used to manipulate those response on every return so that
  /// for every method below, we will only get the value inside the data.
  ResponseManipulator get responseManipulate => _responseManipulate;

  ///By default the token is needed, with 60 seconds timeout and it uses a [defaultResponseManipulator]
  ///
  ///Can be used to override [haveToken], [timeoutSeconds] and [responseManipulator] of the repository
  ///
  /// On not passing [RepositoryDetails], or any of its inner variable, [BaseRepository] value will be used
  RepositoryDetails({
    bool tokenNeeded = true,
    int requestTimeout = 60,
    ResponseManipulator responseManipulate = defaultResponseManipulator,
  })  : _tokenNeeded = tokenNeeded,
        _requestTimeout = requestTimeout,
        _responseManipulate = responseManipulate;

  factory RepositoryDetails.noToken(){
    return RepositoryDetails(tokenNeeded: false);
  }

  static dynamic defaultResponseManipulator(dynamic map) {
    try {
      return map;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return map;
    }
  }

  static dynamic noneResponseManipulator(dynamic map) => map;
}
