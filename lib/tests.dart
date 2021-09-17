import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'common/tools/image_tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future my_Woorewards({required String user_email, String? points}) async {
    try {
      // null safety
      // points = points ?? ''; // if null -> ''
      if (points == '' || points == null) points = '0';

      var url =
          'https://spider3d.co.il/wp-json/woorewards/v1/points/$user_email/_/$points?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872';
      print(url);

      var dio = Dio();
      // if points = '' -> get req | ELSE -> put req
      // final response = points == '' ? await dio.get(url) : await dio.put(url);
      final response = await dio.put(url);

      print(response.data);
      print(response.data[0]['value']);

      // return url;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  // LOG:
  // I/flutter ( 1077): https://spider3d.co.il/wp-json/woorewards/v1/points/eyal@kivi.co.il/_/0?consumer_key=ck_be61455d30704ff30718f80b417dd41c320b0cb0&consumer_secret=cs_79c75a8e1c40acfe530e6254f3cbb61a2e01f872
  // I/flutter ( 1077): [{id: _, points: _, value: 20, rewards: 0}]
  // I/flutter ( 1077): 20

  @override
  void initState() {
    // my_Woorewards(user_email: 'eyal@kivi.co.il');
    my_Woorewards(user_email: 'eyal@kivi.co.il', points: '0');
    super.initState();
  }

  @override
  void dispose() {
    print("D");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Cached Images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child:

              // CachedNetworkImage(
              //   placeholder: (context, url) => CircularProgressIndicator(),
              //   imageUrl:
              //       'https://starwarsblog.starwars.com/wp-content/uploads/2017/05/yoda-advice-featured-1.jpg',
              // ),

              // ExtendedImage.network(
              // 'https://starwarsblog.starwars.com/wp-content/uploads/2017/05/yoda-advice-featured-1.jpg',
              // cache: true,
              // enableLoadState: false,
              // handleLoadingProgress: true,
              // ),

              ImageTools.image(
            // Original card view
            url:
                // 'https://www.spider3d.co.il/wp-content/uploads/2021/07/FB_IMG_1627189910722-large.jpg',
                'https://starwarsblog.starwars.com/wp-content/uploads/2017/05/yoda-advice-featured-1.jpg',
            // isResize: true,
            size: kSize.medium,

            // offset: offset ?? 0.0,
            // fit: kCardFit,
            // width: width,
          ),
        ),
      ),
    );
  }
}
