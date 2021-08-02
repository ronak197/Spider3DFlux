import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:core';

import 'package:inspireui/utils/logs.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// My woorewards API (Source: https://plugins.longwatchstudio.com/docs/woorewards-4/api/users-points/)

// Sample: https://spider3d.co.il/wp-json/woorewards/v1/pools?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872
// Show user points: [GET] /wp-json/woorewards/v1/points/<user_email>/<pool_id>
// Add/ Subtract points: [PUT] /wp-json/woorewards/v1/points/<user_email>/<pool_id>/<points_to_add_or_subtract>

void main() {
  lol();
}

// @override
// Future my_Woorewards({required String user_email, String? points}) async {
//   try {
//     points = points == null ? '' : '$points/'; // set points
//     var url =
//         'https://spider3d.co.il/wp-json/woorewards/v1/points/$user_email/_/$points?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872';
//
//     // var response = await httpGet(endPoint.toUri()!);
//     var response = await httpGet(url);
//
//     //
//     // if (jsonDecode['wp_user_id'] == null || jsonDecode['cookie'] == null) {
//     //   throw Exception(jsonDecode['message']);
//     // }
//     //
//     // return User.fromWooJson(jsonDecode);
//     print(url);
//     print(response);
//     return url;
//   } catch (e) {
//     //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
//     rethrow;
//   }
// }

/// More examples see https://github.com/flutterchina/dio/tree/master/example
void lol() async {
  var dio = Dio();
  final response = await dio.get('https://google.com');
  print(response.data);
}
