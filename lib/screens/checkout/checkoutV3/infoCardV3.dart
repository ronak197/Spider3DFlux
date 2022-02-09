import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:fstore/screens/cart/functions/handleDeliveryFormV3.dart';
import 'package:provider/provider.dart';

import 'delivery_screenV3.dart';

class InfoCardV3 extends StatelessWidget {
  // const InfoCardV3({Key? key}) : super(key: key);
  String mainTitle;
  String title;
  IconData icon;
  bool isPayment;
  InfoCardV3({
    required this.mainTitle,
    required this.title,
    required this.icon,
    required this.isPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child:
          Text('$mainTitle',
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.w600)
                .copyWith(fontSize: 18)
          ),
        ),
        Card(
          color: Theme.of(context).primaryColorLight.withOpacity(0.7),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
          // shadowColor: Colors.black38,
          child: ListTile(
            onTap: () {
              // showBottomSheetFormDialogV3(context);
              showDeliveryFormDialogV3(context);
              // Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryScreenV3()));
            },
            title:
            Consumer<CartModel>(
                builder: (context, model, child) {
                  bool? editField = isPayment ?
                        model.address?.cardNumber == null
                      : model.address?.street == null;
                  var street = model.address?.street;
                  var city = model.address?.city;
                  return Text(editField ? '$title' : '$street, $city',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.w600));
                }
            ),
            leading: Icon(icon, color: Theme.of(context).accentColor,),
            // subtitle: Text('לחץ לעדכון כתובת המשלוח'),
            trailing: Icon(Icons.edit, color: Theme.of(context).accentColor,),
          ),
        ),
      ],
    );
  }
}
