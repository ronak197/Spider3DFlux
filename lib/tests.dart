/// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/screens/my_thingi/thingi_api.dart';
import 'package:fstore/screens/my_thingi/thingi_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart_tests.dart';

void main() async {
  print('start');
  await Firebase.initializeApp();

  // CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');
  var thingi = FirebaseFirestore.instance.collection('thingi')
      .where('users_usage', whereIn: [2, 3, 4, 5, 6, 7, 8, 9]);
  var _users = await thingi.get();
  print(_users.docs.length);
  print(_users.docs.first.data());

  thingi = FirebaseFirestore.instance.collection('thingi')
      .where('users_usage', isEqualTo: 10).limit(1);
  _users = await thingi.get();
  print(_users.docs.length);
  print(_users.docs.first.data());

}
