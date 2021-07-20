import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

import '../../common/constants.dart';

class BlogNews {
  int? id;
  String? date;
  String? title;
  String? author;
  String? content;
  String? excerpt;
  String? slug;
  String? imageFeature;
//  int categoryId;

  BlogNews.empty(this.id) {
    date = '';
    title = 'Loading...';
    author = '';
    content = '';
    excerpt = '';
    imageFeature = '';
  }

  bool isEmptyBlog() {
    return date == '' &&
        title == 'Loading...' &&
        content == 'Loading...' &&
        excerpt == 'Loading...' &&
        imageFeature == '';
  }

  // (my) Attention! API Security setting has been changed to allow this request: https://www.spider3d.co.il/wp-admin/admin.php?page=itsec&path=%2Fsettings%2Fconfigure%2Fadvanced%2Fwordpress-tweaks#rest_api
  // Most of the API still needs acess key (like https://spider3d.co.il/wp-json/wc/v2/products/attributes?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872)
  static Future<dynamic> getBlogs({url, page = 1}) async {
    final response =
        await httpGet('$url/wp-json/wp/v2/posts?page=$page'.toUri()!);
    return json.decode(response.body);
  }

  BlogNews.fromJson(Map<String, dynamic> parsedJson) {
    try {
//      categoryId = parsedJson["categories"][0];
      id = parsedJson['id'];
      slug = parsedJson['slug'];
      title = HtmlUnescape().convert(parsedJson['title']['rendered']);
      content = parsedJson['content']['rendered'];

      var imgJson = parsedJson['better_featured_image'];
      if (imgJson != null && imgJson['media_details'] != null) {
        if (imgJson['media_details']['sizes']['medium_large'] != null) {
          imageFeature =
              imgJson['media_details']['sizes']['medium_large']['source_url'];
        }
      }

      if (imageFeature == null) {
        var imgMedia = parsedJson['_embedded']['wp:featuredmedia'];
        if (imgMedia != null &&
            imgMedia[0]['media_details'] != null &&
            imgMedia[0]['media_details']['sizes']['large'] != null) {
          imageFeature =
              imgMedia[0]['media_details']['sizes']['large']['source_url'];
        }
      }

      if (imageFeature == null || imageFeature!.isEmpty) {
        imageFeature = kDefaultImage;
      }

//      author = parsedJson["_embedded"]["author"][0]["name"];
      excerpt = HtmlUnescape().convert(parsedJson['excerpt']['rendered']);
      date = parsedJson['date'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'imageFeature': imageFeature,
//      "categoryId": categoryId,
      'excerpt': excerpt,
      'date': date,
    };
  }

  BlogNews.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      title = json['title'];
      slug = json['slug'];
      content = json['content'];
      imageFeature = json['imageFeature'];
      excerpt = json['excerpt'];
      date = json['date'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  @override
  String toString() => 'Blog { id: $id title: $title }';
}
