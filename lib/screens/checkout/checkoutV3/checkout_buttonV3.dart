import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:provider/provider.dart';

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
            padding:  const EdgeInsets.symmetric(vertical: 12),
            splashColor: Colors.white24,
            // color: (selectedIndex == index) ?  selectedColor : color,
            color: (Colors.green[600])!,
            onPressed: () {

              print('checkout_buttonV3.dart - Consumer<CartModel>');

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

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              // side: BorderSide(color: color, width: 2, style: BorderStyle.solid),
              /*              side: const BorderSide(
                            color: (Colors.green),
                            width: 3,
                            style: BorderStyle.solid),*/
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.done_all, size: 20, color: Colors.white),
                SizedBox(width: 5),
                Text('סיים הזמנה', textAlign: TextAlign.center,
                  style: TextStyle(
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
