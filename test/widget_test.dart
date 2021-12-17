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

import 'tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  print('response.data0');

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    AddUser();
  });
}
