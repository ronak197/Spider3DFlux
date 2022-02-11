import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';

String checkCheckoutButtonV3(CartModel cartModel) {
  // region A lot of prints.
    // Products (price)
  print('products price:        + ${cartModel.getSubTotal()}');
  // shipping price (price)
  print('shipping price:        + ${cartModel.getShippingCost()}');
  // Coupon (in use, value)
  print('coupon discount value: - ${cartModel.getCouponCost()}');
  print('total price            = ${cartModel.getTotal()}');
  print('----------');
  // shipping method (id, title)
  print('shippingMethod title: ${cartModel.shippingMethod?.title}');
  print('shippingMethod id:    ${cartModel.shippingMethod?.id}');
  // payment method (id, title)
  print('paymentMethod title: ${cartModel.paymentMethod?.title}');
  print('paymentMethod id:    ${cartModel.paymentMethod?.id}');
  print('----------');
  // delivery address details
  print('address firstName:   ${cartModel.address?.firstName}');
  print('address email:       ${cartModel.address?.email}');
  print('address city:        ${cartModel.address?.city}');
  print('address street:      ${cartModel.address?.street}');
  print('----------');
  // payment address details
  print('address cardHolderName:   ${cartModel.address?.cardHolderName}');
  print('address cardCvv:   ${cartModel.address?.cardCvv}');
  print('address cardExpiryDate:   ${cartModel.address?.cardExpiryDate}');
  // user details (logged in, Make sure there is)
  print('----------');
  print('user loggedIn:   ${cartModel.user?.loggedIn}');
  // endregion A lot of prints.

  var errorNotes = '';

  bool _deliveryDetailsOk() {
    print('_deliveryDetailsOk()...');
    if (cartModel.address?.firstName == null ||
        cartModel.address?.firstName == ''   ||
        cartModel.address?.city == null      ||
        cartModel.address?.city == ''        ||
        cartModel.address?.street == null    ||
        cartModel.address?.street == ''      ||
        cartModel.address?.phoneNumber == null ||
        cartModel.address?.phoneNumber == ''   ||
        cartModel.address?.email == null       ||
        cartModel.address?.email == '') {
      print('Something Wrong with _deliveryDetails...');
      return false;
    }

    return true;
  }

  bool _paymentDetailsOk() {
    print('_paymentDetailsOk()...');
    if (cartModel.address?.cardHolderName == null ||
        cartModel.address?.cardHolderName == ''   ||
        cartModel.address?.cardExpiryDate == null ||
        cartModel.address?.cardExpiryDate == '' ||
        cartModel.address?.cardNumber == null   ||
        cartModel.address?.cardNumber == ''     ||
        cartModel.address?.cardCvv == null      ||
        cartModel.address?.cardCvv == ''        ||
        cartModel.address?.cardHolderId == null ||
        cartModel.address?.cardHolderId == '') {
      print('Something Wrong with _paymentDetails...');
      return false;
    }

    return true;
  }

  bool _paymentMethodOk() {
    print('_paymentMethodOk()...');
    if (cartModel.paymentMethod?.title == null ||
        cartModel.paymentMethod?.title == ''   ||
        cartModel.paymentMethod?.id == null    ||
        cartModel.paymentMethod?.id == '') {
      print('Something Wrong with _paymentMethodOk...');
      return false;
    }

    return true;
  }

  bool _shippingMethodOk() {
    print('_paymentMethodOk()...');
    if (cartModel.shippingMethod?.title == null ||
        cartModel.shippingMethod?.title == ''   ||
        cartModel.shippingMethod?.id == null    ||
        cartModel.shippingMethod?.id == '') {
      print('Something Wrong with _shippingMethodOk...');
      return false;
    }

    return true;
  }

  bool _userLoggedOk() {
    print('_userLoggedOk()...');
    if (cartModel.user?.loggedIn == null || cartModel.user?.loggedIn == false) {
      print('Something Wrong with _userLoggedOk...');
      return false;
    }

    return true;
  }

  //         order_status += 'בחר שיטת משלוח \n';
  //         order_status += 'הכנס פרטי משלוח \n';
  //         order_status += 'הכנס פרטי אשראי \n';
  //         order_status += 'בחר אמצעי תשלום \n';

  _deliveryDetailsOk() ? null : errorNotes += ' הכנס כתובת משלוח \n';
  _paymentDetailsOk() ? null : errorNotes += ' הכנס פרטי תשלום \n';

  _paymentMethodOk() ? null : errorNotes += ' בחר שיטת תשלום \n';
  _shippingMethodOk() ? null : errorNotes += ' בחר שיטת משלוח \n';

  _userLoggedOk()  ? null : errorNotes += 'נא התחבר בעמוד הפרופיל \n';
  return errorNotes;
}

SnackBar errSnackBar(context, String errorNotes) {
  return SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    behavior: SnackBarBehavior.floating,
    // padding: const EdgeInsets.only(bottom: 15),
    // backgroundColor: kColorSpiderRed.withOpacity(0.80),
    backgroundColor: Colors.red[500]?.withOpacity(0.85),
    padding: const EdgeInsets.all(10),
    // content: Text(S.of(context).warning(message)),
    content: Text(
      '$errorNotes',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    duration: Duration(seconds: errorNotes.length < 35 ? 4 : 6),
    action: SnackBarAction(
      label: 'סגור',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
}
// ignore: deprecated_member_use

void handleCheckoutButton(context, CartModel cartModel) {
  var errorNotes = checkCheckoutButtonV3(cartModel);
  print('errorNotes: \n$errorNotes');
  Scaffold.of(context).showSnackBar(errSnackBar(context, errorNotes));
}
