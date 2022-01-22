import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:fstore/screens/my_thingi/thingi_screen.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/base_firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// region my thingiToken Setup

// 1. set_thingiToken() - Try prefs.getString('user_token');
// 2. if can't, use getThingiToken() & than prefs.setString('user_token', '$pref_token');

Future<String?> set_thingiToken() async {
  print('set_thingiToken.dart - save_user_token()');

  // Map<String, Object> values = <String, Object>{'user_token': 'Mock_XYZ'};
  // Map<String, Object> values = <String, Object>{};
  // SharedPreferences.setMockInitialValues(values);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  // await storage.clear();

  String? pref_token = prefs.getString('user_token');
  if (pref_token == null || pref_token == 'null') {
    print('A X pref_token is null: ($pref_token)');
    print('Start set user_token..');
    pref_token = await getThingiToken();
    print('B X pref_token after getThingiToken(): ($pref_token)');
    await prefs.setString('user_token', '$pref_token');
  } else {
    print('user_token Found on pref_token! - $pref_token');
  }

  Constants.thingiToken = pref_token;
  print('Constants.thingiToken ${Constants.thingiToken}');
  // return pref_token;
}

Future<String?> getThingiToken() async {
  print('set_thingiToken.dart - getThingiToken()');

// 1. Looking for token with users (usage) Less than 10
// 2. Found: Notify and add + 1 to users (usage), return  selectedToken
// 2. Not found: Notify, return  selectedToken as null

  CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');
  String? selectedToken;

  String? id;
  String token;
  int users_usage = 0;
  var _users = await thingi.get();
  print(_users.docs.length);
  // print(_users.docs.first.data());
  for (var user in _users.docs) {
    // print(user.data());
    id = user.id;
    token = user.get('Token');
    users_usage = user.get('users_usage');
    print(
        '--------------\nusers_usage: $users_usage | Token: $token | doc id: $id');
    if (users_usage < 10) {
      selectedToken = token;
      await thingi
          .doc(id)
          .update({'users_usage': users_usage + 1})
          .then((value) => print('users_usage ++'))
          .catchError((error) => print('Failed to update user: $error'));

      print(
          '${users_usage + 1} / 10 selectedToken: $selectedToken (Success) \n--------------');
      return selectedToken;
    }
  }
  print('selectedToken = $selectedToken (Full)');
  return selectedToken;
}

// Constants.thingiToken = await set_thingiToken();
// print('Constants.thingiToken ${Constants.thingiToken}');

// endregion my thingiToken Setup
