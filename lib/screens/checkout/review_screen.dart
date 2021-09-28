import 'package:flutter/material.dart';
import 'package:fstore/screens/checkout/widgets/payment_methods.dart';
import 'package:fstore/screens/checkout/widgets/shipping_address.dart';
import 'package:fstore/screens/checkout/widgets/shipping_method.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, CartModel, Product, ShippingMethodModel, TaxModel;
import '../../services/index.dart';
import '../../widgets/common/expansion_info.dart';
import '../../widgets/product/cart_item.dart';
import '../base_screen.dart';
import 'checkout_screen.dart';

class ReviewScreen extends StatefulWidget {
  final Function? onBack;
  final Function? onNext;

  ReviewScreen({this.onBack, this.onNext});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends BaseScreen<ReviewScreen> {
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    var notes = Provider.of<CartModel>(context, listen: false).notes;
    note.text = notes ?? '';
    super.initState();
  }

  bool isLoading = false;
  var is_payment_loading = true;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
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

    return ListenableProvider.value(
      value: shippingMethodModel,
      child: Consumer<CartModel>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              kPaymentConfig['EnableShipping']
                  ? ExpansionInfo(
                      // title: S.of(context).shippingAddress,
                      title: 'פרטי משלוח',
                      children: <Widget>[
                        ShippingAddressInfo(),
                        Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 5),
                          child: ButtonTheme(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ShippingAddress()));
                              },
                              child: Text(
                                'ערוך כתובת משלוח',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              ExpansionInfo(
                title: 'מוצרים בהזמנה',
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  ...getProducts(model, context),
                ],
              ),
              Container(
                  height: 1, decoration: const BoxDecoration(color: kGrey200)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(S.of(context).orderDetail,
                    style: const TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      // S.of(context).subtotal,
                      'סכום הזמנה',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
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
              // Builder(builder: (context) => Text('${Provider.of<CartModel>(context).shippingMethod!.title}'),)
              // ChangeNotifierProvider<CartModel>.value(
              // ChangeNotifierProvider<CartModel>.value(
              //     value: shippingMethodModel.shippingMethods,
              //     builder: (context, child) =>,
              //     ),
              model.shippingMethod != null
                  //. ? Text(model.shippingMethod!.title ?? '')
                  ? Services().widget.renderShippingMethodInfo(context)
                  : Container(),
/*                : Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Text(
                        '(יש לבחור שיטת משלוח)',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 14,
                              color: Theme.of(context).accentColor,
                            ),
                      ),
                    ),*/
              //

              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ButtonTheme(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: Theme.of(context).primaryColorLight,
                    ),
                    onPressed: () {
                      Services().widget.loadShippingMethods(
                          context,
                          Provider.of<CartModel>(context, listen: false),
                          false);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                // vertical: 48 * 3
                                vertical:
                                    MediaQuery.of(context).size.height * 0.20,
                              ),
                              // insetPadding: EdgeInsets.zero,
                              // contentPadding: EdgeInsets.zero,
                              title: Text('שיטת משלוח'),
                              content: Services().widget.renderShippingMethods(
                                  context,
                                  onBack: () {},
                                  onNext: () {}),

                              // Actually the same as above
                              // ShippingMethods(
                              //     onBack: () {}, onNext: () {})

                              // goToShippingTab(true);

/*                            actions: <Widget>[
                                TextButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],*/
                            );
                          });
                    },
                    child: Text(
                      'בחר שיטת משלוח',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
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
                    Text(
                      S.of(context).total,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Text(
                      PriceTools.getCurrencyFormatted(
                          model.getTotal(), currencyRate,
                          currency: model.currency)!,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).yourNote,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 6,
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

              Consumer<ShippingMethodModel>(
                builder: (context, shipping_model, child) {
                  // is_payment_loading = true;

                  if (shipping_model.shippingMethods == null) {
                    return Container();
                  }

                  if (shipping_model.isLoading) {
                    return Container(
                        height: 100, child: kLoadingWidget(context));
                  }

/*                  Future.delayed(const Duration(seconds: 1), () {
                    is_payment_loading = false;
                    setState(() {
                      is_payment_loading = false;
                    });
                  });*/

                  // OverLay (Stack) Loading while PaymentMethods is set - could be better
                  Future.delayed(const Duration(seconds: 3)).then((_) {
                    setState(() {
                      is_payment_loading = false;
                      // is_payment_loading != is_payment_loading;
                    });
                    // print(is_payment_loading);
                  });
                  return Stack(
                    children: [
                      PaymentMethods(
                        // onBack: () {
                        //   goToReviewTab(true);
                        // },

                        onFinish: (order) {
                          setState(() {
                            newOrder = order;
                          });
                          Provider.of<CartModel>(context, listen: false)
                              .clearCart();
                        },
                        // onLoading: setLoading)
                        onLoading: setLoading,
                      ),
                      is_payment_loading
                          ? Padding(
                              padding: const EdgeInsets.only(top: 75.0),
                              child: Container(
                                  height: 100, child: kLoadingWidget(context)),
                            )
                          : Container()
                    ],
                  );
                },
              )

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
          my_is_review_screen:
              true, // My adjustments for review_screen.dart only
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

class ShippingAddressInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final address = cartModel.address!;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).firstName + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.firstName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).lastName + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.lastName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).email + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.email!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).streetName + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.street!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).city + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.city!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).stateProvince + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.state!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: Services().widget.getCountryName(context, address.country),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Text(
                          S.of(context).country + ' :',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).phoneNumber + ' :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
