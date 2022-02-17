import 'package:flutter/foundation.dart';

class CheckoutProviderV3 extends ChangeNotifier {

  int paymentIndex = 0; // 1 is credit card by default
  void changePaymentIndex(value) {
    paymentIndex = value;
    print('paymentIndex $paymentIndex');
    notifyListeners();
  }

  int shippingIndex = 0;
  void changeShippingIndex(value) {
    shippingIndex = value;
    print('shippingIndex $shippingIndex');
    notifyListeners();
  }

  String? id;
  String? title;
  String? description;
  bool? enabled;


  // My to allow manually
  // PaymentMethod({this.id, this.title, this.description, this.enabled});
}