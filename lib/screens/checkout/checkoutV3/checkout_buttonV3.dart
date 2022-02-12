import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:provider/provider.dart';

import 'functions/handleCheckoutButtonV3.dart';

class CheckoutButtonV3 extends StatelessWidget {
  const CheckoutButtonV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
        builder: (context, cartModel, child) {
          return Container(
            // height: 80,
            padding: const EdgeInsets.all(12),
            width: 200,
            // width: MediaQuery.of(context).size.width * 0.4,
            // height: MediaQuery.of(context).size.height * 0.0525,
            child: FlatButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              splashColor: Colors.white24,
              // color: (selectedIndex == index) ?  selectedColor : color,
              color:
              // (cartModel.user?.billing?.status == 'Loading') ?
                    (Colors.green[600])!
                  // : Theme.of(context).accentColor.withOpacity(0.85)
              ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // side: BorderSide(color: color, width: 2, style: BorderStyle.solid),
                /*              side: const BorderSide(
                            color: (Colors.green),
                            width: 3,
                            style: BorderStyle.solid),*/
              ),
              onPressed: () {
                // Function afterCheck = ({status}){
                //   status == 'Passed' ? print('Cool.') : print('Try Again.');
                // };
                handleCheckoutButton(context, cartModel /*afterCheck*/);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (cartModel.user?.billing?.status == 'Loading') ?
                  const Icon(Icons.hourglass_bottom, size: 20, color: Colors.white):
                  const Icon(Icons.done_all, size: 20, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    (cartModel.user?.billing?.status == 'Loading')
                        ? 'טוען...' : 'סיים הזמנה'
                    ,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: (Colors.white),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.75,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
