import 'package:flutter/material.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:provider/provider.dart';
import 'RadioButtonV3.dart';
import 'checkoutV3_provider.dart';
import 'checkout_buttonV3.dart';
import 'infoCardV3.dart';
import 'widgets/build_checkoutScreenV3.dart';


// Todo Get products on cart         (From provider)
// Todo Get coupon in use            (From provider)
// Todo Get user detail(s) is logged (From provider)

// Todo Redirect to payment gate and validate (Based /success url)
// Todo Create order on Woo
// Todo Reset order in App

class CheckoutScreenV3 extends StatelessWidget {
  const CheckoutScreenV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color? color = Theme.of(context).primaryColorLight.withOpacity(0.7);
    TextStyle? radioStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: Theme.of(context).accentColor
      // (selectedIndex == index) ? Colors.white : Colors.black,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('עמוד קופה'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Provider.of<CheckoutProviderV3>(context, listen: false).dispose();
              Navigator.of(context).pop();
            }),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 3.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            InfoCardV3(
              mainTitle: 'כתובת משלוח',
              title: 'לחץ לעדכון כתובת משלוח',
              icon: Icons.home,
              isPayment: false,
            ),
            InfoCardV3(
              mainTitle: 'פרטי תשלום',
              title: 'לחץ לעדכון פרטי תשלום',
              icon: Icons.credit_card,
              isPayment: true,
            ),
            buildMainTitle(context, 'שיטת משלוח'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  // shrinkWrap: true, // Set this
                  children: [
                    CustomRadioButtonV3(
                      'עד 3-4 ימי עסקים 29₪', 1,
                      isPayment: false,
                    ),
                    CustomRadioButtonV3('מהיום להיום 45₪', 2,
                        isPayment: false,
                        subText: 'לאשקלון - נתניה, ללא ירושלים ומושבים'),
                    CustomRadioButtonV3(
                      'איסוף עצמי 0₪', 3,
                      isPayment: false,
                      subText: 'פרטי איסוף ישלחו בSMS',
                    ),
                  ],
                ),
              ),
            ),
            buildMainTitle(context, 'שיטת תשלום'),
            SizedBox(
              height: 80,
              child: Row(
                // shrinkWrap: true, // Set this
                // scrollDirection: Axis.horizontal,
                children: [
                  CustomRadioButtonV3(
                    'כרטיס אשראי', 1,
                  ),
                  CustomRadioButtonV3(
                    'מזומן באיסוף עצמי', 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildAddNoteButton(context),

                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        buildRowPrices(context, 'הזמנה:'),
                        buildRowPrices(context, 'משלוח:'),
                        Provider.of<CartModel>(context, listen: false).getCoupon() != '' ?
                        buildRowPrices(context,'קופון:', isCoupon: true) : const SizedBox(),
                        buildRowPrices(context, 'סה"כ:'),
                      ],
                    ),
                  )
                ],
              ),
            ),



            const CheckoutButtonV3(),
            //// Checkout button
            const SizedBox(height: 15),
          ],
        ),
      ),);
  }
}
