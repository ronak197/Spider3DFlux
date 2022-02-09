import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioButtonV3 extends ChangeNotifier {

  int paymentIndex = 0;
  void changePaymentIndex(value) {
    paymentIndex = value;
    notifyListeners();
  }

  int shippingIndex = 0;
  void changeShippingIndex(value) {
    shippingIndex = value;
    notifyListeners();
  }
}

// Todo change the colors in this files to based Theme
class CustomRadioButton extends StatelessWidget {

  final String text;
  final int index;
  final bool isPayment;
  final String? subText;

  CustomRadioButton(this.text, this.index, {this.isPayment = true, this.subText});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).primaryColorLight.withOpacity(0.7);
    Color? selectedColor = Theme.of(context).accentColor;

    return Consumer<RadioButtonV3>(builder: (context, customButton, child) {
      var selectedIndex = isPayment ? customButton.paymentIndex : customButton.shippingIndex;
      // print('$selectedIndex CustomRadioButton Rendered');

      TextStyle? radioStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
          fontWeight:
              (selectedIndex == index) ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: 0.1,
          color: Theme.of(context).accentColor
          // (selectedIndex == index) ? Colors.white : Colors.black,
          );

      return
        Container(
        height: 80,
        width: 130,
        // width: MediaQuery.of(context).size.width * 0.4,
        // height: MediaQuery.of(context).size.height * 0.0525,
        margin: const EdgeInsets.all(5),
        child: FlatButton(
          splashColor: color.withOpacity(0.3),
          // color: (selectedIndex == index) ?  selectedColor : color,
          color: color,
          onPressed: () => isPayment ?
          customButton.changePaymentIndex(index)
          : customButton.changeShippingIndex(index),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // side: BorderSide(color: color, width: 2, style: BorderStyle.solid),
            side: BorderSide(
                color: (selectedIndex == index) ? selectedColor : color,
                width: 2,
                style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, textAlign: TextAlign.center, style: radioStyle),
              subText != null
                  ? Text('$subText',
                      textAlign: TextAlign.center,
                  style: radioStyle.copyWith(fontSize: 10)
              )
                  : Container(),
            ],
          ),
          // borderSide: BorderSide(color: (value == index) ? Colors.green : Colors.black),
        ),
      );
    });
  }
}
