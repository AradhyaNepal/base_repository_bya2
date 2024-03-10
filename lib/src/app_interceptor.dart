
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'base_repository_setup.dart';

class AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    BaseRepositorySetup.onErrorHandleTokenExpiry(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    //Todo: Remove once implemented, until its not implemented, keep annoying the developer
    _notImplementedWarning();
    BaseRepositorySetup.onResponseInterceptor(response);
  }


  //Todo: Remove it once implemented
  //WARNING: DO NOT REMOVE UNTIL THE FEATURE IS IMPLEMENTED
  //BECAUSE YOU MIGHT GET ANNOYED BY BELOW MESSAGE KEEP POPPING ON YOUR LOG
  void _notImplementedWarning() {
    if (!kReleaseMode) {
      log(
          "Warning: Handling Token Expiry Scenario Is Not Handled Yet, Your Api might Crash If Token Get Expired");
    }
  }
}
