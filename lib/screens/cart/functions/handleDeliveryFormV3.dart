import 'package:flutter/material.dart';
import 'package:fstore/screens/checkout/checkoutV3/widgets/delivery_formV3.dart';

void showDeliveryFormDialogV3(BuildContext context) async {
  return showDialog<void>(
    barrierColor: Colors.black26,
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return const AlertDialog(
        // title: const Text('AlertDialog Title'),
        // actions: <Widget>[],
        contentPadding: EdgeInsets.all(0), // inside
        insetPadding: EdgeInsets.all(0), // outside?
        content: SingleChildScrollView(child: DeliveryFormV3()),
      );
    },
  );
}

void showBottomSheetFormDialogV3(BuildContext context) async {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        color: Colors.amber,
        child: const Center(
          child: DeliveryFormV3()
        ),
      );
    },
  );
}
