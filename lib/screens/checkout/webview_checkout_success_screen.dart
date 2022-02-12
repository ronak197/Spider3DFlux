import 'package:flutter/material.dart';
import 'package:fstore/menu/maintab_delegate.dart';

import '../../common/constants.dart';
import '../../models/index.dart' show Order;
import 'widgets/success.dart';

class SuccessScreen extends StatelessWidget {
  final Order? order;
  SuccessScreen({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ההזמנה התקבלה!'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              MainTabControlDelegate.getInstance().changeTab('home');
              Navigator.of(context).popAndPushNamed(RouteList.home);
            }
          ),
        backgroundColor: kGrey200,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: OrderedSuccess(
          order: order,
          isModal: true,
        ),
      ),
    );
  }
}
