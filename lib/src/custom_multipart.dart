import 'dart:io';

import 'package:dio/dio.dart';


import 'package:http_parser/http_parser.dart';

class CustomMultipart {
  ///Never forgot to await, else errors like Multipart: Boundary not found might come
  static Future<Object> awaitParseBody(
    Map<String, dynamic> data, {
    bool removeNull = true,
  }) async {
    final output = FormData.fromMap({
      for (var value in data.entries)
        ...?await _getData(value, removeNull)
    });
    return output;
  }

  static Future<Map<String, dynamic>?> _getData(
      MapEntry mapEntry, bool removeNull) async {
    final fileToUpload = mapEntry.value;
    if (fileToUpload == null && removeNull) return null;
    if (fileToUpload is! File) {
      return {
        mapEntry.key: mapEntry.value,
      };
    } else {
      final fileName = fileToUpload.path.split('/').last;
      return {
        mapEntry.key: await MultipartFile.fromFile(
          fileToUpload.path,
          filename: fileName,
          contentType:MediaType("image", fileName.split(".").last),
        )
      };
    }
  }
}
