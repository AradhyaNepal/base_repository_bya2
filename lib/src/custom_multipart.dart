import 'dart:io';

import 'package:dio/dio.dart';


import 'package:http_parser/http_parser.dart';

class CustomMultipart {
  static Future<Object> parseBody(
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
          contentType:MediaType("images", fileName.split(".").last),
        )
      };
    }
  }
}
