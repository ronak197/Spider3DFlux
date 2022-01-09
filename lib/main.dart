import 'dart:async';
import 'dart:io' show HttpClient;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/screens/wishlist/thingi_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'env.dart';
// import 'env.dart';
// import 'frameworks/vendor_admin/vendor_admin_app.dart';
import 'services/dependency_injection.dart';
import 'services/locale_service.dart';
import 'services/services.dart';

void main() async {
  printLog('[main] ===== START main.dart =======');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Future<String?> save_user_token() async {
    Future<String?> getThingiToken() async {
// 1. Looking for token with users (usage) Less than 10
// 2. Found: Notify and add + 1 to users (usage), return  selectedToken
// 2. Not found: Notify, return  selectedToken as null

      CollectionReference thingi =
          FirebaseFirestore.instance.collection('thingi');
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

    // Map<String, Object> values = <String, Object>{'user_token': 'Mock_XYZ'};
    // Map<String, Object> values = <String, Object>{};
    // SharedPreferences.setMockInitialValues(values);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    String? pref_token = prefs.getString('user_token');
    pref_token == null
        ? {
            pref_token = await getThingiToken(),
            print('Set user_token to pref_token ($pref_token)'),
            await prefs.setString('user_token', '$pref_token')
          }
        : print('user_token is $pref_token');
    return pref_token;
  }

  Constants.thingiToken = await save_user_token();
  print('Constants.thingiToken ${Constants.thingiToken}');

//----------------------------------------------------------------------
  Configurations().setConfigurationValues(environment);
  Provider.debugCheckInvalidValueType = null;
  var languageCode =
      kAdvanceConfig['DefaultLanguage'] ?? Configurations.defaultLanguage;

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runZonedGuarded(() async {
    if (!foundation.kIsWeb) {
      /// Enable network traffic logging.
      HttpClient.enableTimelineLogging = !foundation.kReleaseMode;

      /// Lock portrait mode.
      unawaited(SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]));

      Tools.initStatusBarColor();
    }

    if (isMobile) {
      await GmsTools().checkGmsAvailability();

      /// Init Firebase settings due to version 0.5.0+ requires to.
      /// Use await to prevent any usage until the initialization is completed.
      await Services().firebase.init();

      await DependencyInjection.inject();

      if (kAdvanceConfig['AutoDetectLanguage'] == true) {
        final lang = injector<SharedPreferences>().getString('language');

        if (lang?.isEmpty ?? true) {
          languageCode = await LocaleService().getDeviceLanguage();
        } else {
          languageCode = lang.toString();
        }
      }
    }

    // if (serverConfig['type'] == 'vendorAdmin') {
    //   return runApp(VendorAdminApp(
    //     locale: languageCode,
    //   ));
    // }

    ResponsiveSizingConfig.instance.setCustomBreakpoints(
        const ScreenBreakpoints(desktop: 900, tablet: 600, watch: 100));
    runApp(
        App(languageCode: languageCode)
    );
  }, (e, stack) {
    printLog(e);
    printLog(stack);
  });
}
