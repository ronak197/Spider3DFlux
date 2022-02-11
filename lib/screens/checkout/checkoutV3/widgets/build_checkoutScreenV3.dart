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

Container buildNotesButton(BuildContext context) {

  TextStyle? radioStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Theme.of(context).accentColor
    // (selectedIndex == index) ? Colors.white : Colors.black,
  );

  Color? color = Theme.of(context).primaryColorLight.withOpacity(0.7);

  return Container(
    height: 50,
    width: 100,
    // width: MediaQuery.of(context).size.width * 0.4,
    // height: MediaQuery.of(context).size.height * 0.0525,
    margin: const EdgeInsets.all(5),
    child: FlatButton(
      splashColor: color.withOpacity(0.3),
      // color: (selectedIndex == index) ?  selectedColor : color,
      color: color,
      onPressed: () async {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: BorderSide(color: color, width: 2, style: BorderStyle.solid),
        side: BorderSide(
            color: color,
            width: 2,
            style: BorderStyle.solid),
      ),
      child: Text('הוסף הערה', textAlign: TextAlign.center, style: radioStyle),
      // borderSide: BorderSide(color: (value == index) ? Colors.green : Colors.black),
    ),
  );
}