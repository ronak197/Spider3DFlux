import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fstore/common/theme/colors.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:fstore/models/entities/address.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/screens/checkout/widgets/my_creditcard_address.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';


class DeliveryFormV3 extends StatelessWidget {
  const DeliveryFormV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _nameController = TextEditingController();
    var _cityController = TextEditingController();
    var _streetController = TextEditingController();
    var _phoneController = TextEditingController();
    var _emailController = TextEditingController();

    final _cityNode = FocusNode();
    final _streetNode = FocusNode();
    final _phoneNode = FocusNode();
    final _emailNode = FocusNode();

    // Address? address; // Does it necessary?

    return Consumer<CartModel>(
      builder: (context, model, child) {
        // print('UserModel Details:');
        // print('user loggedIn? ${model.user?.loggedIn}');
        // print('user name: ${model.user?.name}');
        // print('user email: ${model.user?.email}');

        if (kDebugMode) {
          print('CartModel Details:');
          print('cart loggedIn? ${model.user?.loggedIn}');
          print('cart user ${model.user}');
          print('cart address ${model.address}');
          print('cart checkout ${model.checkout}');
        }

        if (model.user?.username != null) _nameController.text = '${model.user?.username}';
        if (model.address?.city != null) _cityController.text = '${model.address?.city}';
        if (model.address?.street != null) _streetController.text = '${model.address?.street}';
        if (model.address?.phoneNumber != null) {
          _phoneController.text = '${model.address?.phoneNumber}';}
        if (model.address?.email != null) _emailController.text = '${model.address?.email}';

        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            // color: Color(0xfff1f1f1),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Form(
                  // key: _formKey, //   final _formKey = GlobalKey<FormState>();
                  child: AutofillGroup( // Do we really need those?
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            decoration: greyTxtDeco(labelText: 'שם לחשבונית'),
                            controller: _nameController,
                            autofillHints: [AutofillHints.givenName],
                            textInputAction: TextInputAction.next,
                            autofocus: model.user?.username != null ? false : true, // focus if empty
                            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_cityNode),
                            validator: (val) =>
                                val!.isEmpty ? S.of(context).firstNameIsRequired : null,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 7,
                                child: TextFormField(
                                  decoration: greyTxtDeco(labelText: 'עיר'),
                                  controller: _cityController,
                                  autofillHints: [AutofillHints.addressCity],
                                  focusNode: _cityNode,
                                  textInputAction: TextInputAction.next,
                                  autofocus:
                                  model.user?.username != null
                                  && model.address?.city == null
                                      ? true : false, // focus if name already filled
                                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_streetNode),
                                  validator: (val) =>
                                     val!.isEmpty ? S.of(context).cityIsRequired : null,
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Flexible(
                                flex: 11,
                                child: TextFormField(
                                    decoration: greyTxtDeco(labelText: 'רחוב, מס׳ בית'),
                                    controller: _streetController,
                                    autofillHints: [
                                      AutofillHints.fullStreetAddress
                                    ],
                                    focusNode: _streetNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneNode),
                                    validator: (val) =>
                                       val!.isEmpty ? S.of(context).streetIsRequired : null,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 9,
                                child: TextFormField(
                                    decoration: greyTxtDeco(labelText: 'טלפון'),
                                    controller: _phoneController,
                                    autofillHints: [AutofillHints.telephoneNumber],
                                    focusNode: _phoneNode,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailNode),
                                    validator: (val) {
                                        // print('val.length');
                                        // print(val!.length);
                                        return val!.length != 10 ? 'הזן טלפון תקין' : null;
                                        },
                                    ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Flexible(
                                flex: 9,
                                child: TextFormField(
                                    decoration: greyTxtDeco(labelText: 'אימייל'),
                                    controller: _emailController,
                                    autofillHints: [AutofillHints.email],
                                    focusNode: _emailNode,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    validator: (val) {
                                      if (val!.isEmpty) return S.of(context).emailIsRequired;
                                      return validateEmail(val);
                                    },
                                    onFieldSubmitted: (_) async {
                                      await _handleDoneButton(context);
                                    },),
                              ),
                            ],
                          ),
                          Center(
                            child: ButtonTheme(
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  onPrimary: Colors.white,
                                  primary: Theme
                                      .of(context)
                                      .primaryColor,
                                ),
                                onPressed: () async {
                                  await _handleDoneButton(context);
                                },
                                child: const Text('עדכן',
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
                // Services().widget.renderShippingMethods(context, onBack: () {}, onNext: () {}),
              ],
            ),
          ),
        );
      }
    );
  }
  String? validateEmail(String value) {
    var valid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (valid) {
      return null;
    }
    return 'הזן דוא״ל תקין';
  }

  Future _handleDoneButton(BuildContext context) async {
      // Provider.of<CartModel>(context, listen: false).setAddress(address);

      var myAddress =
      await Provider.of<CartModel>(context, listen: false).getAddress();

      // await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Checkout()));
  }
}
