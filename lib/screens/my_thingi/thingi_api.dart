/*
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// 0 בחירת טוקן מהמאגר לAPI ///
CollectionReference thingi = FirebaseFirestore.instance.collection('thingi');
String? selectedToken;
Future<String?> getThingiToken() async {
// 1. Looking for token with users (usage) Less than 10
// 2. Found: Notify and add + 1 to users (usage), return  selectedToken
// 2. Not found: Notify, return  selectedToken as null

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

// var thingiToken = '76a96e8a8905232b8f9d1645eeada242';
var thingiToken = getThingiToken();

/// 1 חיבור לAPI ///
var defaultList = ['featured', 'popular', 'verified', 'newest'];
var randomHome = defaultList[Random().nextInt(defaultList.length)];

var categoriesList = [
  '3d-printing',
  'art',
  'fashion',
  'gadgets',
  'hobby',
  'household',
  'learning',
  'models',
  'tools',
  'toys-and-games',
];
var randomCategory = categoriesList[Random().nextInt(categoriesList.length)];

class Constants {
  //https://api.thingiverse.com/popular/?access_token=$thingiToken
  static String defaultFeed =
      'https://api.thingiverse.com/$randomHome/?access_token=$thingiToken';
  // 'https://api.thingiverse.com/search/dog/?access_token=$thingiToken';
  // static String defaultFeed = 'https://api.thingiverse.com/$randomHome/?access_token=$thingiToken';

  static String feedByKeyword(String keyword) {
    return 'https://api.thingiverse.com/search/$keyword?access_token=$thingiToken'; //אפשר לשים כאן כל דבר, לייתר ביטחון...
  }

  // static String feedByCategory(String category) {
  static String feedByCategory() {
    return 'https://api.thingiverse.com/categories/$randomCategory/things?access_token=$thingiToken'; //אפשר לשים כאן כל דבר, לייתר ביטחון...
  }
}

class Webservice {
  Future<String> setFeedByPopular() async {
    // Future<Map<String, dynamic>> setFeedByPopular() async {
    print('setFeedByPopular:');
    print('thingiToken $thingiToken');
    final response = await http.get(Uri.parse(Constants.defaultFeed));
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      // throw Exception('Failed to get news');
      return "{'hits': 'my null'}";
    }
  }

  Future setFeedByKeyword(String keyword) async {
    /// קטע זה מאפשר את יכולת החיפוש
    print('setFeedByKeyword');
    print('thingiToken $thingiToken');

    final response =
        await http.get(Uri.parse(Constants.feedByKeyword(keyword)));
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to get news');
    }
  }

  Future<String> setFeedByCategory(String category) async {
    print('setFeedByCategory');
    print('thingiToken $thingiToken');

    final response = await http.get(Uri.parse(Constants.feedByCategory()));
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to get news');
    }
  }
}

void main() async {
  // List<dynamic> postList = jsonDecode(await Webservice().setFeedByCategory());
  // Map<String, dynamic> postDictionary = {'hits': postList};

  // var postDictionary = await Webservice().setFeedByPopular();
  print('Start');
  // print(postDictionary);
  // print(postDictionary.entries.map((e) => print(e.value)));

  for (var counter = 0; counter < postDictionary['hits'].length; counter++) {
    var current_post = postDictionary['hits'][counter];
    print(postDictionary['hits'][counter]['name']);
    break;
  }


  print('Done');
}
*/
