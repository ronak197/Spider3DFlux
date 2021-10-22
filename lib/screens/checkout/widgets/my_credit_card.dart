import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:fstore/screens/checkout/widgets/payment_methods.dart';
import 'package:fstore/screens/checkout/widgets/shipping_address.dart';
import 'package:fstore/screens/checkout/widgets/shipping_method.dart';
import 'package:provider/provider.dart';
import 'package:awesome_card/awesome_card.dart';

import 'dart:math' as math;

import 'my_creditcard_address.dart';

var show_creditCard_details = true;

class CreditCardInfo extends StatefulWidget {
  @override
  State<CreditCardInfo> createState() => _CreditCardInfoState();
}

class _CreditCardInfoState extends State<CreditCardInfo> {
  @override
  Widget build(BuildContext context) {
    if (show_creditCard_details) {
      print('show_creditCard_details');
      print(show_creditCard_details);
      return Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      // S.of(context).firstName + ' :',
                      'בעל הכרטיס :',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'XX YY',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      // S.of(context).firstName + ' :',
                      'מס כרטיס :',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '**** **** **** 2743',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 0, bottom: 5, top: 10),
              child: ButtonTheme(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => ShippingAddress(
                    //           onNext: () {},
                    //           isFullPage: true,
                    //         )));
                    setState(() {
                      show_creditCard_details = false;
                    });
                  },
                  child: Text(
                    'עדכן כרטיס אשראי',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('show_creditCard_details');
      print(show_creditCard_details);
      return CreditCardAddress(
        onNext: () {},
        isFullPage: false,
      );
    }
  }
}
