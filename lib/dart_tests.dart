// import 'frameworks/woocommerce/services/woo_commerce.dart';

import 'dart:convert';
// import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:fstore/common/constants.dart';
import 'package:http/http.dart' as http;

/// 1 חיבור לAPI ///
var defaultList = ['featured', 'popular', 'verified', 'newest'];
// var randomHome = randomChoice(defaultList);
var thingiToken = '76a96e8a8905232b8f9d1645eeada242';

class Constants {
  //https://api.thingiverse.com/popular/?access_token=$thingiToken
  static String defaultFeed =
      'https://api.thingiverse.com/search/news?access_token=$thingiToken';
  // static String defaultFeed =  'https://api.thingiverse.com/$randomHome/?access_token=$thingiToken';

  static String feedByKeyword(String keyword) {
    return 'https://api.thingiverse.com/search/$keyword?access_token=$thingiToken'; //אפשר לשים כאן כל דבר, לייתר ביטחון...
  }

  static String feedByCategory(String category) {
    return 'https://api.thingiverse.com/categories/$category/things?access_token=$thingiToken'; //אפשר לשים כאן כל דבר, לייתר ביטחון...
  }
}

class Webservice {
  // Future<String> setFeedByPopular() async {
  Future<Map<String, dynamic>> setFeedByPopular() async {
    print('setFeedByPopular:');
    final response = await http.get(Uri.parse(Constants.defaultFeed));
    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      // throw Exception('Failed to get news');
      return {'hits': 'my null'};
    }
  }

  Future setFeedByKeyword(String keyword) async {
    /// קטע זה מאפשר את יכולת החיפוש
    print('B');
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
    /// קטע זה מאפשר את יכולת החיפוש
    print('C');
    final response =
        await http.get(Uri.parse(Constants.feedByCategory(category)));
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to get news');
    }
  }
}

void main() async {
  // Map<String, dynamic> postDictionary = jsonDecode(await Webservice().setFeedByPopular());
  print('Start');
  // print(postDictionary.entries.map((e) => print(e.value)));

/*  for (var counter = 0; counter < postDictionary['hits'].length; counter++) {
    var current_post = postDictionary['hits'][counter];
    print(current_post['name']);
  }*/

  print('Done');
}
