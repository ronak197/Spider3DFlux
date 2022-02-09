import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fstore/screens/checkout/checkoutV3/widgets/build_widgetsV3.dart';
import 'RadioButtonV3.dart';
import 'checkout_buttonV3.dart';
import 'infoCardV3.dart';

class CheckoutScreenV3 extends StatelessWidget {
  const CheckoutScreenV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('עמוד קופה'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 3.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            InfoCardV3(
              mainTitle: 'כתובת משלוח',
              title: 'חבקוק 114 גדרה',
              icon: Icons.home,
            ),
            InfoCardV3(
              mainTitle: 'פרטי תשלום',
              title: '2743 **** **** ****',
              icon: Icons.credit_card,
            ),
            buildMainTitle(context, 'שיטת תשלום'),
            SizedBox(
              height: 80,
              child: ListView(
                shrinkWrap: true, // Set this
                scrollDirection: Axis.horizontal,
                children: [
                  CustomRadioButton(
                    'כרטיס אשראי',
                    1,
                  ),
                  CustomRadioButton(
                    'מזומן באיסוף עצמי',
                    2,
                  ),
                ],
              ),
            ),
            buildMainTitle(context, 'שיטת משלוח (3)'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  // shrinkWrap: true, // Set this
                  children: [
                    CustomRadioButton(
                      'עד 3-4 ימי עסקים 29₪',
                      1,
                      isPayment: false,
                    ),
                    CustomRadioButton('מהיום להיום 45₪', 2,
                        isPayment: false,
                        subText: 'לאשקלון - נתניה, ללא ירושלים ומושבים'),
                    CustomRadioButton(
                      'מזומן באיסוף עצמי 0₪',
                      3,
                      isPayment: false,
                      subText: 'פרטי איסוף ישלחו בSMS',
                    ),
                  ],
                ),
              ),
            ),

            buildRowPrices(context, '249', 'עלות הזמנה'),
            buildRowPrices(context, '29', 'עלות משלוח'),
            buildRowPrices(context, '278', 'סה"כ'),

            const CheckoutButtonV3(),
            //// Checkout button
            // const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
