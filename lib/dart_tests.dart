import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inspireui/extensions/string_extension.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:intl/intl.dart';

import 'models/entities/shipping_method.dart';

// import '../../../common/constants.dart';
// import 'common/constants.dart';
// import '../../../models/index.dart';
// import 'index.dart';
// import 'models/entities/shipping_method.dart';

var headers = {'Cookie': 'PHPSESSID=e203768c5e152412e8c7d566fc3fe8a6'};
var request = httpPost(''.toUri()!,
    // body: convert.jsonEncode(params),
    headers: {'Content-Type': 'application/json'});

/*request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) async {
print(await response.stream.bytesToString());
}
else {
print(response.reasonPhrase);*/
// }

/// The default http POST that support Logging
Future<http.Response> httpPost(Uri url,
    {Map<String, String>? headers, Object? body}) async {
  final startTime = DateTime.now();
  if (enableDio) {
    try {
      final res = await Dio().post(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain),
          data: body);
      // printLog('POST:$url', startTime);
      final response = http.Response(res.toString(), res.statusCode!);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        final response =
            http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message;
      }
    }
  } else {
    final response = await http.post(url, headers: headers, body: body);
    // printLog('POST:$url', startTime);
    return response;
  }
}

void main() async {
  var list = <ShippingMethod>[];
  // var url = 'https://spider3d.co.il/wp-json/api/flutter_woo/shipping_methods';
  var url = 'https://spider3d.co.il';
  final response =
      await httpPost('$url/wp-json/api/flutter_woo/shipping_methods'.toUri()!,
          // body: convert.jsonEncode(params),
          headers: {'Content-Type': 'application/json'});
  print('getShippingMethods A');
  // final body = convert.jsonDecode(response.body);
  var body = await json.decode(json.encode(response.body)); // My
  print('getShippingMethods B');
  print(body);
  if (response.statusCode == 200) {
    print('response.statusCode == 200');
    for (var item in body) {
      list.add(ShippingMethod.fromJson(item));
    }
    print("Body req: (shipping_methods)");
    // print(convert.jsonEncode(params));
    print("Body resp: (shipping_methods)");
    print(body);
  } else if (body['message'] != null) {
    throw Exception(body['message']);
  }
  if (list.isEmpty) {
    throw Exception(
        'Your selected address is not supported by any Shipping method, please update the billing address again!');
  }
}
