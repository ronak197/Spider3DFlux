import 'package:flutter/material.dart';

/// A build methods widgets for checkout_screenV3.dart
Widget buildRowPrices(BuildContext context, String price, String type) {
  TextStyle _style(bool isBold){
    return Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 16);
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$type', style: _style(false),),
        Text('$price₪', style: _style(true),)],
    ),
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