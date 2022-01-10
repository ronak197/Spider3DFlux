import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fstore/screens/checkout/shippingInfoTile.dart';
import 'package:fstore/screens/checkout/widgets/checkout_button.dart';
import 'package:fstore/screens/checkout/widgets/my_credit_card.dart';
import 'package:fstore/screens/checkout/widgets/payment_methods.dart';
import 'package:fstore/screens/checkout/widgets/shipping_form.dart';
import 'package:fstore/screens/checkout/widgets/shipping_method.dart';
import 'package:fstore/widgets/product/product_variant.dart';
import 'package:provider/provider.dart';
import 'package:awesome_card/awesome_card.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show
        Address,
        AppModel,
        CartModel,
        PaymentMethodModel,
        Product,
        ShippingMethodModel,
        TaxModel,
        UserModel;
import '../../services/index.dart';
import '../../widgets/common/expansion_info.dart';
import '../../widgets/product/cart_item.dart';
import '../base_screen.dart';
import 'checkout_screen.dart';
import 'dart:math' as math;

var paymentFormOpen = false;

class ReviewScreen extends StatefulWidget {
  final Function? onBack;
  final Function? onNext;

  // final Address? addressDetails;

  ReviewScreen({
    this.onBack,
    this.onNext,
    // this.addressDetails
  });

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends BaseScreen<ReviewScreen> {
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    final ScrollController _controller = ScrollController();

    void _scrollDown() {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
    // paymentFormOpen ? _scrollDown() : null;

    var notes = Provider.of<CartModel>(context, listen: false).notes;
    note.text = notes ?? '';

    Services().widget.loadShippingMethods(
        context, Provider.of<CartModel>(context, listen: false), false);

/*    int? selectedIndex =
        0; // right for 26.9.21, 0 means the "29₪ 2-3 day delivery" is default
    Future.delayed(
      Duration.zero,
      () async {
        print('לB My deafult shipping method');
        final shippingMethod =
            Provider.of<CartModel>(context, listen: false).shippingMethod;
        final cartModel = Provider.of<CartModel>(context, listen: false);

        Services().widget.loadShippingMethods(
            context, Provider.of<CartModel>(context, listen: false), false);

        print('לC My deafult shipping method');
        final shippingMethods =
            Provider.of<ShippingMethodModel>(context, listen: false)
                .shippingMethods;
        if (shippingMethods != null &&
            shippingMethods.isNotEmpty &&
            shippingMethod != null) {
          final index = shippingMethods
              .indexWhere((element) => element.id == shippingMethod.id);
          if (index > -1) {
            setState(() {
              selectedIndex = index;
            });
          }

          print('D My deafult shipping method');
          print(cartModel.shippingMethod!.title ?? 'Null..');
        }

        */

    // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DetailScreen()));

    // widget.onNext!();
    super.initState();
  }

  bool isPaymentLoading = false;

  void setPaymentLoading(bool loading) {
    setState(() {
      isPaymentLoading = loading;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<TaxModel>(context, listen: false).getTaxes(
        Provider.of<CartModel>(context, listen: false), (taxesTotal, taxes) {
      Provider.of<CartModel>(context, listen: false).taxesTotal = taxesTotal;
      Provider.of<CartModel>(context, listen: false).taxes = taxes;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final shippingMethodModel = Provider.of<ShippingMethodModel>(context);
    // var myShippingTitle = Provider.of<CartModel>(context).shippingMethod!.title;

    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final taxModel = Provider.of<TaxModel>(context);
    var cartModel = Provider.of<CartModel>(context);
    var dropdownValue = '1';

    // region note
    // is it the first time the FutureBuilder load? - Provider.of<CartModel>(context, listen: false).getAddress(),
    // var firstDeliveryFuture = true;

    // final address = cartModel.address!;
    // var address = cartModel.address; // My

    // var getAddress = Provider.of<CartModel>(context, listen: false).getAddress();

/*    var address;
    @override
    void initState() {
      // print('widget.addressDetails');
      // print(widget.addressDetails);
      super.initState();
      Future.delayed(
        Duration.zero,
        () async {
          final addressValue =
              await Provider.of<CartModel>(context, listen: false).getAddress();
          address = addressValue;

          print("addressValue:");
          print(addressValue!.firstName);
          print(addressValue.city);
          // ignore: unnecessary_null_comparison
        },
      );
    }

    initState();*/
    // endregion note

    return ListenableProvider.value(
      value: shippingMethodModel,
      child: Consumer<CartModel>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Text(S.of(context).orderDetail,
                    style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 1, decoration: const BoxDecoration(color: kGrey200)),
              const SizedBox(
                height: 15,
              ),
              ExpansionInfo(
                iconWidget: Icon(
                  Icons.widgets,
                  color: Theme.of(context).accentColor,
                  // color: Color(0xff263238), size: 20,
                  size: 20,
                ),
                title: 'מוצרים בהזמנה',
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  ...getProducts(model, context),
                ],
              ),

              const SizedBox(height: 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Visibility(
                  visible: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        // S.of(context).subtotal,
                        'סכום הזמנה',
                        style: TextStyle(
                            fontSize: 15,
                            color:
                                Theme.of(context).appBarTheme.backgroundColor),
                      ),
                      Text(
                        PriceTools.getCurrencyFormatted(
                            model.getSubTotal(), currencyRate,
                            currency: model.currency)!,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 14,
                              color: Theme.of(context).accentColor,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future:
                    Provider.of<CartModel>(context, listen: false).getAddress(),
                // Provider.of<CartModel>(context),
                builder: (context, snapshot) {
                  Address address;
                  String final_title;
                  bool fullFormData;

                  if (snapshot.hasData) {
                    // print('Snapshott have data.');
                    address = snapshot.data as Address;
                    // print(address.city);
                    // print(address.street);

                    fullFormData = address.street != null &&
                        address.street != '' &&
                        address.city != null &&
                        address.phoneNumber != '' &&
                        address.phoneNumber != null &&
                        address.city != '';

                    final_title = fullFormData
                        ? 'כתובת: ' '${address.city}, ' '${address.street!}'
                        : 'הכנס כתובת משלוח';
                  } else {
                    // return const Text('Snapshot currntly have no data');
                    print('Snapshott currntly have no data..');
                    fullFormData = false;
                    // address = snapshot.data as Address;
                    // print(address);

                    final_title = 'הכנס כתובת משלוח';
                  }

                  // print('full_address_data: $fullFormData');

                  return Column(
                    children: [
                      Container(
                        // 1. Without key: ExpansionInfo can't rebuild again
                        // 2. With UniqueKey(): ExpansionInfo rebuild to many
                        // 3. with Key(final_title): the 2 situations (has/'nt data) get 2 keys
                        key: Key(final_title),
                        child: ExpansionInfo(
                          // if form data empty: open (and show form)
                          expand: !fullFormData,
                          // expand: true,
                          iconWidget: Transform(
                            transform: Matrix4.rotationY(math.pi),
                            origin: const Offset(11, 0),
                            child: Icon(
                              Icons.home,
                              color: Theme.of(context).accentColor,
                              // color: Color(0xff263238), size: 20,
                            ),
                          ),
                          // title: S.of(context).shippingAddress,
                          // title: 'פרטי משלוח',
                          // title: 'כתובת: לאונדרניו השני, תל אביב יפו העתיקה',
                          title: final_title,
                          // title: address != null ? 'כתובת: ''${address.city}, ''${address.street}' : 'עדכן כתובת משלוח',
                          children: <Widget>[
                            fullFormData
                                ? ShippingInfoTile()
                                : ShippingForm(
                                    onNext: () {},
                                    isFullPage: false,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Container(
                        // 1. Without key: ExpansionInfo can't rebuild again
                        // 2. With UniqueKey(): ExpansionInfo rebuild to many
                        // 3. with Key(final_title): the 2 situations (has/'nt data) get 2 keys
                        key: Key(selectedPaymentId.toString()),
                        child: ExpansionInfo(
                          expand: selectedPaymentId == null, // open if no data
                          // expand: true,
                          iconWidget: Transform(
                            transform: Matrix4.rotationY(math.pi),
                            origin: const Offset(11, 0),
                            child: Icon(
                              Icons.local_shipping,
                              color: Theme.of(context).accentColor,
                              // color: Color(0xff263238), size: 20,
                            ),
                          ),

                          title: selectedPaymentId ==  null ? 'בחר שיטת משלוח ותשלום' : '000',
                          // title: address != null ? 'כתובת: ''${address.city}, ''${address.street}' : 'עדכן כתובת משלוח',
                          children: <Widget>[
                            fullFormData
                            // && !paymentFormOpen
                            /// Deliver radio widget
                                ? Services().widget.renderShippingMethods(context,
                                onBack: () {}, onNext: () {
                                  setPaymentLoading(true);
                                })
                                : Container(),
                            Container(
                                height: 1,
                                decoration: const BoxDecoration(color: kGrey200)),
                            const SizedBox(
                              height: 15,
                            ),

                            /// Payment radio widget
                            selectedShippingIndex != null
                            // ? Container()
                                ? Consumer<ShippingMethodModel>(
                              builder: (context, shipping_model, child) {
                                // is_payment_loading = true;

                                if (shipping_model.shippingMethods == null) {
                                  return Container();
                                }

                                if (shipping_model.isLoading) {
                                  // setPaymentLoading(true); // Set state no needed
                                  isPaymentLoading = true;
                                }

/*                  Future.delayed(const Duration(seconds: 1), () {
                        is_payment_loading = false;
                        setState(() {
                          is_payment_loading = false;
                        });
                      });*/

                                // OverLay (Stack) Loading while PaymentMethods is set - could be better
                                Future.delayed(const Duration(seconds: 4))
                                    .then((_) {
                                  try {
                                    setPaymentLoading(false);
                                  } catch (e, trace) {
                                    print('my trace: $trace');
                                  }
                                  // print(is_payment_loading);
                                });
                                return Stack(
                                  children: [
                                    PaymentMethodsRadio(),
                                    isPaymentLoading
                                        ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 75.0),
                                      child: Container(
                                          height: 100,
                                          child: kLoadingWidget(context)),
                                    )
                                        : Container()
                                  ],
                                );
                              },
                            )
                            // ,
                                : Container(),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                    ],
                  );
                },
              ),

              Container(
                key: UniqueKey(),
                child: ExpansionInfo(
                  expand: paymentFormOpen,
                  iconWidget: Transform(
                    transform: Matrix4.rotationY(math.pi),
                    origin: const Offset(11, 0),
                    child: Icon(
                      Icons.credit_card,
                      color: Theme.of(context).accentColor,
                      // color: Color(0xff263238), size: 20,
                    ),
                  ),
                  // title: S.of(context).shippingAddress,
                  // title: 'פרטי משלוח',
                  // title: 'כתובת: לאונדרניו השני, תל אביב יפו העתיקה',
                  // title: 'פרטי כרטיס (2743 **** **** ****)',
                  title: cartModel.address?.cardNumber != null
                      ? 'פרטי כרטיס: ${cartModel.address?.cardNumber?.substring(12, 16)} **** **** ****'
                      : 'הכנס פרטי אשראי',
                  // title: address != null ? 'כתובת: ''${address.city}, ''${address.street}' : 'עדכן כתובת משלוח',
                  children: <Widget>[CreditCardInfo()],
                ),
              ),

              if (model.getCoupon() != '')
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        S.of(context).discount,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        model.getCoupon(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 14,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    ],
                  ),
                ),
              Services().widget.renderTaxes(taxModel, context),
              Services().widget.renderRewardInfo(context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // region note
                    // QuantitySelection(
                    //   enabled: false,
                    //   width: 60,
                    //   height: 32,
                    //   color: Theme.of(context).accentColor,
                    //   limitSelectQuantity: 12,
                    //   value: 1,
                    //   onChanged: () {},
                    //   useNewDesign: false,
                    // ),

                    // תשלומים
                    /*               DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.keyboard_arrow_down,
                              size: 14,
                              color: Theme.of(context).appBarTheme.backgroundColor),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              fontSize: 14, color: Theme.of(context).accentColor),
                          underline: Container(
                            height: 32,
                            width: 200,
                            decoration: BoxDecoration(
                              color: kGrey200.withOpacity(0.7),
                              // border: Border.all(width: 1.0, color: kGrey200),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            // '6',
                            // '7',
                            // '8',
                            // '9',
                            // '10',
                            // '11',
                            // '12',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),*/
                    // endregion note
                    Text(
                      S.of(context).total,
                      style:
                          // TextStyle(fontSize: 16, color: Theme.of(context).accentColor,),
                          TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .backgroundColor),
                    ),
                    Text(
                      PriceTools.getCurrencyFormatted(
                          model.getTotal(), currencyRate,
                          currency: model.currency)!,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            // decoration: TextDecoration.underline,
                          ),
                    )
                  ],
                ),
              ),

              // Container(height: 1, decoration: const BoxDecoration(color: kGrey200)),

              const SizedBox(height: 15),
              Text(
                S.of(context).yourNote,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kGrey200,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      printLog(value);
                      // if (note.text.isNotEmpty) {
                      Provider.of<CartModel>(context, listen: false)
                          .setOrderNotes(note.text);
                      // }
                      // printLog(note.text);
                      // printLog(Provider.of<CartModel>(context, listen: false).notes);
                    },
                    cursorColor: Colors.red[900],
                    maxLines: 2,
                    controller: note,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                        // hintText: S.of(context).writeYourNote,
                        hintText: 'כתוב הערה (אופציונלי)',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none),
                  )),
              const SizedBox(
                height: 10,
              ),

              CheckoutButton(
                onBack: () {},

                onFinish: (order) {
                  setState(() {
                    newOrder = order;
                  });
                  Provider.of<CartModel>(context, listen: false).clearCart();
                },
                // onLoading: setLoading)
                onLoading: setPaymentLoading,
              ),
              // CheckoutButton()

/*            if (kPaymentConfig['EnableShipping'] &&
                      kPaymentConfig['EnableAddress'])
                    Center(
                        child: TextButton(
                            onPressed: () {
                              widget.onBack!();
                            },
                            child: Text(S.of(context).goBackToShipping,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    color: kGrey400))))*/
            ],
          );
        },
      ),
    );
  }

  List<Widget> getProducts(CartModel model, BuildContext context) {
    return model.productsInCart.keys.map(
      (key) {
        var productId = Product.cleanProductID(key);

        return ShoppingCartRow(
          my_is_review_screen: true,
          // My adjustments for review_screen.dart only
          addonsOptions: model.productAddonsOptionsInCart[key],
          product: model.getProductById(productId),
          variation: model.getProductVariationById(key),
          quantity: model.productsInCart[key],
          options: model.productsMetaDataInCart[key],
        );
      },
    ).toList();
  }
}
