import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:provider/provider.dart';

/// A build methods widgets for checkout_screenV3.dart
Widget buildRowPrices(
    BuildContext context,
    String type,
    {bool isCoupon = false }) {

  TextStyle _style(bool isBold){
    return Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 16);
  }

  return Consumer<CartModel>(
    builder: (context, cartModel, child) {
      /*                 buildRowPrices(context, '249', 'עלות הזמנה'),
                  buildRowPrices(context, '29', 'עלות משלוח'),
                  buildRowPrices(context, '29', 'הנחת קופון'),
                  buildRowPrices(context, '278', 'סה"כ'),*/
      String? price;
      switch (type){
        case 'עלות הזמנה': price = '${cartModel.getSubTotal()}';
          break;
        case 'עלות משלוח': price = '${cartModel.getShippingCost()}';
          break;
        case 'הנחת קופון': price = '${cartModel.getCouponCost()}';
          break;
        case 'סה"כ': price = '${cartModel.getTotal()}';
          break;
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(' $type', style: _style(false),),
            Text( isCoupon ?
                 '$price₪ -'
                :'$price₪  ',
              style: _style(true),)],
            // Text('$price₪ -', style: _style(true),)],
        ),
      );
    }
  );
}

Container buildMainTitle(BuildContext context, String title) {
  return Container(
    alignment: Alignment.centerRight,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Text('$title',
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(fontWeight: FontWeight.w600)
            .copyWith(fontSize: 18)),
  );
}