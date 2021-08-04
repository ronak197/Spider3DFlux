import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show UserModel, UserPoints;
import '../../services/index.dart' show Config;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:fstore/screens/users/spider_point_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../app.dart';
import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show AppModel, User, UserModel, WishListModel;
import '../../models/notification_model.dart';
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import '../../widgets/common/webview.dart';
import '../index.dart';
import '../posts/post_screen.dart';
import '../users/user_point_screen.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SpidersPointScreen extends StatefulWidget {
  @override
  _StateUserPoint createState() => _StateUserPoint();
}

class _StateUserPoint extends State<SpidersPointScreen> {
  final dateWidth = 100;
  final pointWidth = 50;
  final borderWidth = 0.5;

  // Future<UserPoints> getUserPoint() async {
  //   final userModel = Provider.of<UserModel>(context, listen: false);
  //   final points = await httpGet(
  //       '${Config().url}/wp-json/api/flutter_user/get_points/?insecure=cool&user_id=${userModel.user!.id}'
  //           .toUri()!);
  //   print("UserPoints:");
  //   print(UserPoints.fromJson(json.decode(points.body)));
  //   return UserPoints.fromJson(json.decode(points.body));
  // }

  Future<String> my_Woorewards(
      {required String user_email, String? points}) async {
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
      final resp = await dio.put(url);

      // print(response.data);
      // print(response.data[0]['value']);
      return resp.data[0]['value'].toString();
      // return resp.data[0]['value'];
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Row(
            children: [
              const Icon(CupertinoIcons.money_dollar_circle),
              Text(
                ' קאשבק & ספיידרס',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        body: FutureBuilder<String>(
          future: my_Woorewards(user_email: 'eyal@kivi.co.il'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Align(
                alignment: Alignment.center,
                child: kLoadingWidget(context),
              );
            }
            if (!snapshot.hasData) return Container();
            var spiderPoints = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      trailing: Text(
                        // 'snapshot.data!.points.toString()',
                        spiderPoints,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                              fontSize: 30,
                            ),
                      ),
                      title: const Text(
                        'מטבעות ספיידרס:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // subtitle: Text(
                      //   'יש לך 30 ספיידרס ששווים 3₪ \nהקאשבק שלך יופעל אוטומטית ברכישה הבאה.',
                      //   style: TextStyle(
                      //
                      //       fontWeight: FontWeight.w600,
                      // color:
                      //     Theme.of(context).accentColor.withOpacity(0.75),
                      // ),
                      // ),
                    ),
                    const Divider(indent: 15.0, endIndent: 15.0),
                    ListTile(
                      title: Text(
                        'יש לך $spiderPoints ספיידרס ששווים ${double.parse(spiderPoints) / 10}₪ \nהקאשבק שלך יופעל אוטומטית ברכישה הבאה.',
                        style: TextStyle(
                          fontSize: 15,
                          //    fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).accentColor.withOpacity(0.75),
                        ),
                      ),
                    ),
                    const Divider(indent: 15.0, endIndent: 15.0),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'איך משיגים ספיידרס?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // for (var event in snapshot.data!.events)
                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '50+',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            title: const Text('שיתוף האפליקציה במדיה חברתית',
                                style: TextStyle(fontSize: 16)),
                            subtitle: Text(
                              'תקבל 50 ספיידר על השיתוף',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '50+',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            title: Row(
                              children: [
                                const Text('הזמנת חבר לאפליקציה',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    color: Colors.amber,
                                    padding: const EdgeInsets.all(3.0),
                                    child: const Text(' מומלץ! ',
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'תקבל 50 ספיידר על הזמנה',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.grey[700]),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    // backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
                                    elevation: MaterialStateProperty.all(2)),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.person_add,
                                  size: 20,
                                ),
                                label: const Text(
                                  'הזמן חבר',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 20.0,
                                    // color: kGrey900,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton.icon(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.grey[700]),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    // backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
                                    elevation: MaterialStateProperty.all(2)),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share,
                                  size: 20,
                                ),
                                label: const Text(
                                  'שתף אותנו',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 20.0,
                                    // color: kGrey900,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '10+',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            title: const Text('דירוג מוצרים באתר',
                                style: TextStyle(fontSize: 16)),
                            subtitle: Text(
                              'תקבל 10 ספיידר על כל דירוג',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '1+',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            title: const Text('הזמנת פילמנים וחומרי הדפסה',
                                style: TextStyle(fontSize: 16)),
                            subtitle: Text(
                              'תקבל 1 ספיידר על כל 10₪',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
