import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

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
              ExtendedImage.network(
            'https://starwarsblog.starwars.com/wp-content/uploads/2017/05/yoda-advice-featured-1.jpg',
            cache: true,
            enableLoadState: false,
            handleLoadingProgress: true,
            // loadStateChanged:
            // (ExtendedImageState state) {
            //   Widget? widget;
            //   switch (state.extendedImageLoadState) {
            //     case LoadState.loading:
            //       widget = hidePlaceHolder
            //           ? const SizedBox()
            //           : Skeleton(
            //         width: width ?? 100,
            //         height: width ?? 100 * ratioImage * 2,
            //       );
            //       break;
            //     case LoadState.completed:
            //       widget = ExtendedRawImage(
            //         image: state.extendedImageInfo?.image,
            //         width: width,
            //         height: height,
            //         fit: fit,
            //       );
            //       break;
            //     case LoadState.failed:
            //       widget = Container(
            //         width: width,
            //         height: height ?? width! * ratioImage,
            //         color: const Color(kEmptyColor),
            //       );
            //       break;
            //   }
            //   return widget;
            // },
          ),
        ),
      ),
    );
  }
}
