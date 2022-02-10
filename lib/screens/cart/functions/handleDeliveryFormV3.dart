import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';
import '../../checkout/checkoutV3/widgets/delivery_formV3.dart';
import 'package:fstore/screens/checkout/checkoutV3/widgets/payment_formV3.dart';

void showDeliveryFormDialogV3(BuildContext context, bool isPayment) async {
  return showDialog<void>(
    barrierColor: Colors.black26,
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        // actions: <Widget>[],
        contentPadding: const EdgeInsets.all(0), // inside
        insetPadding: const EdgeInsets.all(15), // outside
        content: SingleChildScrollView(
            child: isPayment ?
            const PaymentFormV3()
          : const DeliveryFormV3()),
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
        child: const Center(child: DeliveryFormV3()),
      );
    },
  );
}
