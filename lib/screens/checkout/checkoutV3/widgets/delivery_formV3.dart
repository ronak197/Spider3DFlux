import 'package:flutter/material.dart';
import 'package:fstore/common/theme/colors.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:fstore/models/entities/address.dart';
import 'package:fstore/screens/checkout/widgets/my_creditcard_address.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';


class DeliveryFormV3 extends StatelessWidget {
  const DeliveryFormV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _streetController = TextEditingController();
    final TextEditingController _blockController = TextEditingController();
    final TextEditingController _zipController = TextEditingController();
    final TextEditingController _stateController = TextEditingController();
    final TextEditingController _countryController = TextEditingController();
    final TextEditingController _apartmentController = TextEditingController();


    final _phoneNode = FocusNode();
    final _emailNode = FocusNode();
    final _cityNode = FocusNode();
    final _streetNode = FocusNode();

    Address? address;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        // color: Color(0xfff1f1f1),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Form(
              // key: _formKey, //   final _formKey = GlobalKey<FormState>();
              child: AutofillGroup(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        // initialValue:  address!.firstName,
                        autofillHints: [AutofillHints.givenName],
                        decoration: greyTxtDeco(labelText: 'שם לחשבונית'),
                        // const InputDecoration(
                        // //     labelText: S.of(context).firstName
                        // labelText: 'שם לחשבונית'),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return val!.isEmpty
                              ? S
                              .of(context)
                              .firstNameIsRequired
                              : null;
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context)
                                .requestFocus(_cityNode),
                        onSaved: (String? value) {
                          address!.firstName = value;
                        },
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: TextFormField(
                              // controller: _cityController,
                              // initialValue:  address!.city,
                              autofillHints: [AutofillHints.addressCity],
                              focusNode: _cityNode,
                              validator: (val) {
                                return val!.isEmpty
                                    ? S
                                    .of(context)
                                    .cityIsRequired
                                    : null;
                              },
                              decoration: greyTxtDeco(
                                  labelText: S
                                      .of(context)
                                      .city),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context)
                                      .requestFocus(_streetNode),
                              onSaved: (String? value) {
                                address!.city = value;
                              },
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Flexible(
                            flex: 11,
                            child: TextFormField(
                              // controller: _streetController,
                              // initialValue:  address!.street,
                                autofillHints: [
                                  AutofillHints.fullStreetAddress
                                ],
                                focusNode: _streetNode,
                                validator: (val) {
                                  return val!.isEmpty
                                      ? S
                                      .of(context)
                                      .streetIsRequired
                                      : null;
                                },
                                decoration: greyTxtDeco(
                                  // labelText: S.of(context).streetName
                                    labelText: 'רחוב, מס׳ בית'),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context)
                                        .requestFocus(_phoneNode),
                                onSaved: (String? value) {
                                  address!.street = value;
                                }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 9,
                            child: TextFormField(
                              // initialValue:  address!.phoneNumber,
                                autofillHints: [
                                  AutofillHints.telephoneNumber
                                ],
                                focusNode: _phoneNode,
                                decoration: greyTxtDeco(
                                  // labelText: S.of(context).phoneNumber
                                  labelText: 'טלפון',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  print('val.length');
                                  print(val!.length);
                                  return val.length != 10
                                      ? 'הזן טלפון תקין'
                                      : null;
                                },
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context)
                                        .requestFocus(_emailNode),
                                onSaved: (String? value) {
                                  address!.phoneNumber = value;
                                }),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Flexible(
                            flex: 9,
                            child: TextFormField(
                              // initialValue:  address!.email,
                                autofillHints: [AutofillHints.email],
                                focusNode: _emailNode,
                                keyboardType: TextInputType.emailAddress,
                                decoration: greyTxtDeco(
                                    labelText: S
                                        .of(context)
                                        .email),
                                textInputAction: TextInputAction.done,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return S
                                        .of(context)
                                        .emailIsRequired;
                                  }
                                  return validateEmail(val);
                                },
                                onFieldSubmitted: (_) async {
                                  await _handleDoneButton(context);
                                },
                                onSaved: (String? value) {
                                  address!.email = value;
                                }),
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
                            child: const Text('המשך',
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
