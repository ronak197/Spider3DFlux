// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<void> main() async {
  final parameters = DynamicLinkParameters(
    uriPrefix:
        'https://spider3dflux.page.link', // uri prefix used for Dynamic Links in Firebase Console
    link: Uri.parse('https://www.spider3d.co.il/'),
    androidParameters: AndroidParameters(
      packageName: 'com.biton.spider3dflux',
      // minimumVersion: 25,
    ),
    iosParameters: IosParameters(
      bundleId: 'com.biton.spider3dflux',
      // minimumVersion: '1.0.1',
      // appStoreId: '1405860595',
    ),
  );

  final shortDynamicLink = await parameters.buildShortLink();
  print(shortDynamicLink);
}
