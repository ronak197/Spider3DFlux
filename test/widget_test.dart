import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  print('response.data0');

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    print('response.data1');
    // Build our app and trigger a frame.
    // await tester.pumpWidget(AppMaster());
    await myApi_req();
  });
}

Future<int?> myApi_req() async {
  var dio = Dio();
  final response = await dio.get('https://google.com');
  print('response.data2');
  print(response.data);
  print(response.statusCode);
  return response.statusCode;
}
