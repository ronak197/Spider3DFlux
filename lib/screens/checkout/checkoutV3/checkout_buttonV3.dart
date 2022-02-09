import 'package:flutter/material.dart';


class CheckoutButtonV3 extends StatelessWidget {
  const CheckoutButtonV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
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
}
