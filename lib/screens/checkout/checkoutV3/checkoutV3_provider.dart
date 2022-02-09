import 'package:flutter/foundation.dart';

class CheckoutProviderV3 extends ChangeNotifier {

  int paymentIndex = 1;
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
}