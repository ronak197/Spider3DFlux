import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'common/tools/image_tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print("S");
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

    void l() {
      print("L");
    }

    ;
    l();

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
