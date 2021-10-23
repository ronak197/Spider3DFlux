import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_pickers/country.dart' as picker_country;
import 'package:country_pickers/country_pickers.dart' as picker;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show Address, CartModel, Country, CreditCard, CreditCardModel, UserModel;
import '../../../services/index.dart';
import '../../../widgets/common/place_picker.dart';
import '../checkout_screen.dart';
import '../choose_address_screen.dart';
import '../review_screen.dart';
import 'my_credit_card.dart';
import 'package:credit_card_validator/credit_card_validator.dart';

class CreditCardAddress extends StatefulWidget {
  final bool isFullPage;
  final Function onNext;

  CreditCardAddress({required this.onNext, this.isFullPage = true});

  @override
  _CreditCardAddressState createState() => _CreditCardAddressState();
}

class _CreditCardAddressState extends State<CreditCardAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final CreditCardValidator _ccValidator = CreditCardValidator();

  final _phoneNode = FocusNode();
  final _emailNode = FocusNode();
  final _cityNode = FocusNode();
  final _streetNode = FocusNode();

  Address? creditCard;
  List<Country>? countries = [];
  List<dynamic> states = [];
  var cardType; // My

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();

    _phoneNode.dispose();
    _emailNode.dispose();
    _cityNode.dispose();
    _streetNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("Start CreditCardAddress init");
    Future.delayed(
      Duration.zero,
      () async {
        final addressValue =
            await Provider.of<CartModel>(context, listen: false).getAddress();
        // final creditCardValue = Provider.of<CreditCardModel>(context, listen: false)             .getCreditCard();
        // ignore: unnecessary_null_comparison
        if (addressValue != null) {
          setState(() {
            creditCard = addressValue;
            print('creditCard');
            print(creditCard.toString());
            print(creditCard);
            print(creditCard!.cvv);
            print(creditCard!.cvv.toString());
            // _cityController.text = creditCard?.city ?? '';
            // _streetController.text = creditCard?.street ?? '';
          });
        }
        // My comment
/*        else {
          var user = Provider.of<UserModel>(context, listen: false).user;
          setState(() {
            creditCard = Address(country: kPaymentConfig['DefaultCountryISOCode']);
            if (kPaymentConfig['DefaultStateISOCode'] != null) {
              creditCard!.state = kPaymentConfig['DefaultStateISOCode'];
            }

            if (user != null) {
              creditCard!.firstName = user.firstName;
              creditCard!.lastName = user.lastName;
              creditCard!.email = user.email;
            }
          });
        }
        countries = await Services().widget.loadCountries(context);
        var country = countries!.firstWhereOrNull((element) =>
            element.id == creditCard!.country || element.code == creditCard!.country);
        if (country == null) {
          if (countries!.isNotEmpty) {
            country = countries![0];
            creditCard!.country = countries![0].code;
          } else {
            country = Country.fromConfig(creditCard!.country, null, null, []);
          }
        } else {
          creditCard!.country = country.code;
          creditCard!.countryId = country.id;
        }
        if (mounted) {
          setState(() {});
        }
        states = await Services().widget.loadStates(country);
        if (mounted) {
          setState(() {});
        }*/
      },
    );
  }

  Future<void> updateState(Address? address) async {
    setState(() {
      _cityController.text = address?.city ?? '';
      _streetController.text = address?.street ?? '';

      // this.creditCard?.country = address?.country ?? '';
    });
  }

  bool checkToSave() {
    final storage = LocalStorage('address');
    var _list = <Address>[];
    try {
      var data = storage.getItem('data');
      if (data != null) {
        (data as List).forEach((item) {
          final add = Address.fromLocalJson(item);
          _list.add(add);
        });
      }
      for (var local in _list) {
        if (local.city != _cityController.text) continue;
        if (local.street != _streetController.text) continue;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).yourAddressExistYourLocal),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            );
          },
        );
        // print('checkToSave Bool is false');
        // return false;
        print('checkToSave Bool false is overwrite to true //My');
        return true;
      }
    } catch (err) {
      printLog(err);
    }
    print('checkToSave Bool is true');
    return true;
  }

  Future<void> saveDataToLocal() async {
    final storage = LocalStorage('address');
    var _list = <Address?>[];
    _list.add(creditCard);
    try {
      final ready = await storage.ready;
      if (ready) {
        var data = storage.getItem('data');
        if (data != null) {
          (data as List).forEach((item) {
            final add = Address.fromLocalJson(item);
            _list.add(add);
          });
        }
        await storage.setItem(
            'data',
            _list.map((item) {
              // return item!.toJsonEncodable();
              return item!.toJson();
            }).toList());

/*        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(S.of(context).youHaveBeenSaveAddressYourLocal),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      S.of(context).ok,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              );
            });*/
      }
    } catch (err) {
      printLog(err);
    }
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

  @override
  Widget build(BuildContext context) {
    var countryName = S.of(context).country;

    // if (creditCard == null) {
    //   return Container(height: 100, child: kLoadingWidget(context));
    // }
    return widget.isFullPage
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              // backgroundColor: Theme.of(context).backgroundColor,
              backgroundColor: Color(0xfff1f1f1),
              title: Text(
                S.of(context).shippingAddress,
                // 'llll',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Center(
                child: IconButton(
                  onPressed: () async {
                    if (!checkToSave()) return;
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Provider.of<CartModel>(context, listen: false)
                          .setAddress(creditCard);
                      await saveDataToLocal();

                      // Navigator.pop(context);

                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Checkout()));
                    }

                    var myAddress =
                        await Provider.of<CartModel>(context, listen: false)
                            .getAddress();
                    print("myAddress:");
                    print(myAddress!.cardHolderName);
                    print(myAddress.expiryDate);
                    print(myAddress.cardNumber);
                    print(myAddress.cvv);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).accentColor,
                  iconSize: 20,
                ),
              ),
            ),
            body: formWidget())
        : formWidget();
  }

  Widget formWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            // color: Color(0xfff1f1f1),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Flexible(
                                  flex: 10,
                                  child: TextFormField(
                                    // initialValue:  address!.firstName,
                                    autofillHints: [
                                      AutofillHints.creditCardName,
                                      // AutofillHints.creditCardFamilyName,
                                      // AutofillHints.creditCardGivenName,
                                      // AutofillHints.creditCardMiddleName,
                                    ],
                                    decoration:
                                        greyTxtDeco(labelText: 'שם בעל כרטיס'),
                                    // const InputDecoration(
                                    // //     labelText: S.of(context).firstName
                                    // labelText: 'שם לחשבונית'),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    validator: (val) {
                                      return val!.isEmpty
                                          // ? S.of(context).firstNameIsRequired
                                          ? 'תקן שדה זה'
                                          : null;
                                    },
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_phoneNode),
                                    onSaved: (String? value) {
                                      creditCard!.cardHolderName = value;
                                    },
                                  ),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                Flexible(
                                  flex: 10,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                          // initialValue:  address!.phoneNumber,
                                          autofillHints: [
                                            AutofillHints
                                                .creditCardExpirationDate
                                          ],
                                          focusNode: _phoneNode,
                                          // textAlign: TextAlign.center,
                                          decoration: greyTxtDeco(
                                            // labelText: S.of(context).phoneNumber
                                            labelText: 'תוקף MM / YY',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          validator: (val) {
                                            // var isValid = _ccValidator
                                            //     .validateExpDate(val!)
                                            //     .isValid;

                                            // print(val!.length == 4 ? 'V' : 'X');

                                            var valid_month = int.parse(val
                                                    .toString()
                                                    .substring(0, 2)) <=
                                                12;

                                            // var yy = int.parse(
                                            //     val.toString().substring(2, 4));

                                            // print('mm $mm');
                                            // print(mm <= 12);
                                            // print('yy $yy');
                                            // print(yy < 31);

                                            return val!.length == 4 &&
                                                    valid_month
                                                ? null
                                                : 'תאריך במבנה 1212';
                                          },
                                          keyboardType: TextInputType.number,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .requestFocus(_emailNode),
                                          onSaved: (String? value) {
                                            creditCard!.expiryDate = value;
                                          }),
                                      // Center(
                                      //   child: RotationTransition(
                                      //     turns: const AlwaysStoppedAnimation(
                                      //         15 / 360),
                                      //     child: Container(
                                      //       margin: const EdgeInsets.symmetric(
                                      //           vertical: 4.0),
                                      //       color: Colors.grey,
                                      //       height: 30,
                                      //       width: 1.5,
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 14,
                                  child: TextFormField(
                                    // initialValue:  address!.firstName,
                                    autofillHints: [
                                      AutofillHints.creditCardNumber
                                    ],
                                    decoration:
                                        greyTxtDeco(labelText: 'מס׳ כרטיס'),
                                    // const InputDecoration(
                                    // //     labelText: S.of(context).firstName
                                    // labelText: 'שם לחשבונית'),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,

                                    onChanged: (value) {
                                      cardType = _ccValidator
                                          .validateCCNum(value)
                                          .ccType;
                                      print('cardType is $cardType');
                                    },

                                    validator: (val) {
                                      var isValid = _ccValidator
                                          .validateCCNum(val!)
                                          .isValid;

                                      // return val!.isEmpty
                                      //     ? S.of(context).firstNameIsRequired
                                      //     : null;

                                      // print('isValid is $isValid');
                                      return isValid
                                          ? null
                                          : 'הזן מס׳ כרטיס תקין';
                                    },
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_phoneNode),
                                    onSaved: (String? value) {
                                      creditCard!.cardNumber = value;
                                    },
                                  ),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                Flexible(
                                  flex: 7,
                                  child: TextFormField(
                                    autofillHints: [
                                      AutofillHints.creditCardSecurityCode
                                    ],
                                    focusNode: _cityNode,
                                    validator: (val) {
                                      var isCvvValid = _ccValidator
                                          .validateCVV(val!, cardType)
                                          .isValid;

                                      // return val!.isEmpty
                                      //     ? S.of(context).firstNameIsRequired
                                      //     : null;

                                      // print('isValid is $isValid');
                                      return isCvvValid ? null : 'תקן שדה זה';
                                    },
                                    decoration:
                                        greyTxtDeco(labelText: '3 ספרות'),
                                    textInputAction: TextInputAction.next,
                                    // onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_apartmentNode),
                                    onSaved: (String? value) {
                                      creditCard!.cvv = value;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            /*          TextFormField(
                              controller: _zipController,
                              autofillHints: [AutofillHints.postalCode],
                              focusNode: _zipNode,
                              validator: (val) {
                                return val!.isEmpty ? S.of(context).zipCodeIsRequired : null;
                              },
                              keyboardType:
                                  (kPaymentConfig['EnableAlphanumericZipCode'] ?? false)
                                      ? TextInputType.text
                                      : TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(labelText: S.of(context).zipCode),
                              onSaved: (String? value) {
                                address!.zipCode = value;
                              }),*/
                            // const SizedBox(height: 20),
                            Center(
                              child: ButtonTheme(
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    onPrimary: Colors.white,
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    if (!checkToSave()) return;
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      Provider.of<CartModel>(context,
                                              listen: false)
                                          .setAddress(creditCard);
                                      await saveDataToLocal();

                                      var myAddress =
                                          await Provider.of<CartModel>(context,
                                                  listen: false)
                                              .getAddress();
                                      print("The CC Details:");
                                      print(myAddress!.cardHolderName);
                                      print(myAddress.cardNumber);
                                      print(myAddress.expiryDate);
                                      print(myAddress.cvv);

                                      setState(() {
                                        show_creditCard_details = true;
                                      });
                                    }
                                  },
                                  child: const Text('שמור',
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
          ),
        ),
      ),
    );
  }
}

class MyFadePush<T> extends PageRoute<T> {
  MyFadePush(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.white;

  @override
  String get barrierLabel => 'barrierLabel';

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

InputDecoration greyTxtDeco(
    {hintText, /*icons, svgIcon,*/ helperText, labelText}) {
  return InputDecoration(
    counter: const Offstage(
        /*Counter Here*/), //וויג'ט שמסתיר ויזואלית את קיומו של הילד שלו
    filled: true,
    fillColor: Colors.black.withOpacity(0.05),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10), //.only(left: 10, right: 10, top: 10, bottom: 10),
    // helperText: helperText,
    // helperMaxLines: 2,
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.grey[500], //Hexcolor("#808c8e")
      // fontFamily: "Assistant",
      // fontWeight: FontWeight.w600,
    ),
    hintStyle: TextStyle(
      color: Colors.grey[500], //Hexcolor("#808c8e")
      // fontFamily: "Assistant",
      // fontWeight: FontWeight.w600,
    ),

    // prefixIcon: Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 13),
    //   child:  SvgPicture.asset(svgIcon, color: spiderRed, height: 24,),
    // // Icon(icons, color: spiderRed,)
    // ),

    errorStyle: const TextStyle(
        //fontSize:14, color: Colors.red,
        // fontFamily: "Assistant", fontWeight: FontWeight.w600,
        ),

    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white, width: 0)),

    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white, width: 0)),

    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white, width: 0)),
  );
}