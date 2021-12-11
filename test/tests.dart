import 'dart:convert';
import 'package:chaleno/chaleno.dart';
import 'package:fstore/common/constants.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

import 'dart:io';
import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';

void main() async {
  print('start');
  // List<StlFinderPost> posts = await getPosts();
  List posts = await getPosts();
  posts.map((e) => print(e.post_image));
  print('Done');
}

Future<List> getPosts() async {
  // Start the browser and go to a web page
  var browser = await puppeteer.launch();
  var page = await browser.newPage();
  var posts_list = [];
  // List posts_list;

  // Setup the dimensions and user-agent of a particular phone
  await page.emulate(puppeteer.devices.pixel2XL);

  await page.goto(
    'http://www.thingiverse.com/search?q=dog&type=things&sort=relevant',
    // 'http://www.flutter.dev',
    // wait: Until.networkIdle
  );
  var pageContent = await page.content;
  print('pageContent');
  print(pageContent.runtimeType);
  // print(pageContent);

  var parse_resp = parse(pageContent);
  // print(parse_resp.body);
  // print(parse_resp.body?.text);
  for (var item in parse_resp.getElementsByTagName('a')) {
    var post_url;
    var post_jpg;

    if (item.outerHtml.contains('thing:') &&
        !item.outerHtml.contains('thing:0/edit')) {
      // print('item.outerHtml');
      // <a class="ThingCardBody__cardBodyWrapper--ba5pu" href="https://www.thingiverse.com/thing:1388237"><img src="https://cdn.thingiverse.com/renders/72/9b/25/74/d3/73a4f0a870dc45f0c98546cf89e8d8c3_preview_card.jpg" alt="Make Card"></a>
      // print(item.outerHtml);
      // >>> URL
      var url = item.attributes['href'];
      print(url);
      post_url = url;
      // >>> IMG
      var img = item.outerHtml.replaceAll('$url', '');
      RegExp exp =
          new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

      Iterable<RegExpMatch> matches = exp.allMatches(img);

      matches.forEach((match) {
        print(img.substring(match.start, match.end));
        post_jpg = img.substring(match.start, match.end);
      });

      posts_list.add(StlFinderPost(post_url: post_url, post_image: post_jpg));
      print('posts_list length is ${posts_list.length}');
    }
  }

/*  await page.evaluate("var x = document.querySelectorAll('a')");
  await page.evaluate("console.log('x.length document')");
  await page.evaluate("console.log(x.length)");
  await page.evaluate("var y = document.querySelectorAll('href')");
  await page.evaluate("console.log('y.length document')");
  await page.evaluate("console.log(y.length)");*/

/*  var parse_content = parse(pageContent);
  print('parse_content.outerHtml');
  print(parse_content.outerHtml);
  print('parse_content.body');
  print(parse_content.body?.text);
  print('parse_content.text');
  print(parse_content.text);*/

  // var screenshot = await page.screenshot();
  // await File('_github.png',).writeAsBytes(screenshot);

  await browser.close();
  return posts_list;
}

class StlFinderPost {
  String? post_image;
  // String? post_id;
  // String? post_name;
  String? post_url;

  StlFinderPost(
      {
      // this.post_id,
      this.post_image,
      // this.post_name,
      this.post_url});
}

/// My woorewards API (Source: https://plugins.longwatchstudio.com/docs/woorewards-4/api/users-points/)

// Sample: https://spider3d.co.il/wp-json/woorewards/v1/pools?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872
// Show user points: [GET] /wp-json/woorewards/v1/points/<user_email>/<pool_id>
// Add/ Subtract points: [PUT] /wp-json/woorewards/v1/points/<user_email>/<pool_id>/<points_to_add_or_subtract>

/*void main() async {
  printLog('Start');
  // var dio = Dio();
  // final response = await dio.get(
  //     'https://www.thingiverse.com/search?q=dog&type=things&sort=relevant');
  // var parse_resp = parse(response.data);
  //
  // // var header = parser?.getElementsByClassName('title')[0].text;
  // // var subscribeCount = parser?.querySelector('.subscribers-count-note').text;
  // // var img = response?.querySelector('.jsx-1373700303 img').src;
  //
  // printLog(parse_resp.documentElement?.outerHtml);
  // printLog(parse_resp.querySelectorAll('a').length);
  // printLog(parse_resp.querySelectorAll('href').length);
  // printLog(parse_resp.querySelectorAll('div').length);

  http.Response response = await http.get(Uri.parse(
      'https://www.thingiverse.com/search?q=dog&type=things&sort=relevant'));

  Document document = parser.parse(response.body);

  document.querySelectorAll('a').forEach((Element element) {
    print(element.text);
  });

  printLog('Done');
}*/

/*Future myApi_req() async {
  var dio = Dio();
  final response =
      await dio.get('https://www.stlfinder.com/3dmodels/?search=dog&free=1');
  var parse_resp = parse(response.data);
  print(response.statusCode);
  // print(parse_resp.body);
  // print(parse_resp.body?.text);
  for (var s in parse_resp.getElementsByTagName('source')) {
    // >>> Get photo
    var current_url = s.outerHtml.toString();
    if (current_url.contains('.jpg')) {
      current_url = current_url.replaceAll('<source srcset="', '');
      current_url = current_url.replaceAll('" type="image/jpeg">', '');
      print(current_url);

      // >>> Get ID
      var current_id = current_url;
      current_id = current_id.replaceAll(
          'https://storage.googleapis.com/stlfinder/', '');
      current_id = current_id.replaceAll('_200.jpg', '');
      for (var l in current_id.split('')) {
        current_id = current_id.replaceFirst(l, '');
        // print(current_id);
        if (l == '/') break;
      }
      print(current_id);

      // >>> Get Url
    }
    // print(s.outerHtml);
  }
}*/

/*
Future myApi_req() async {
  var dio = Dio();
  final response = await dio.get(
      'https://www.thingiverse.com/search?q=dog&type=things&sort=relevant');
  // 'https://www.stlfinder.com/3dmodels/?search=dog&free=1');
  var parse_resp = response.data;
  print(response.statusCode);
  // print(parse_resp.body);
  print(parse_resp);
  var x = parse_resp.querySelectorAll('a');
  print(x);
  // print(x.first.outerHtml);
  // print(x.first.innerHtml);
  // print(x.first.text);
}
*/
