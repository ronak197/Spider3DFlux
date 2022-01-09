import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show CartModel, Order;
import '../../services/index.dart';
import '../../widgets/product/product_bottom_sheet.dart';
import '../base_screen.dart';
import 'review_screen.dart';
import 'widgets/payment_methods.dart';
import 'widgets/shipping_form.dart';
import 'widgets/success.dart';

class Checkout extends StatefulWidget {
  final PageController? controller;
  final bool? isModal;

  Checkout({this.controller, this.isModal});

  @override
  _CheckoutState createState() => _CheckoutState();
}

Order? newOrder;

class _CheckoutState extends BaseScreen<Checkout> {
  int tabIndex = 0;
  bool isPayment = false;
  bool isLoading = false;
  // var getAddressDetails;

  @override
  void initState() {
/*    Future.delayed(
      Duration.zero,
      () async {
        final addressValue =
            await Provider.of<CartModel>(context, listen: false).getAddress();
        getAddressDetails = addressValue;

        print('addressValue from checkout_screen.dart:');
        print(addressValue!.firstName);
        print(addressValue.city);
        // ignore: unnecessary_null_comparison
      },
    );*/
    super.initState();
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!kPaymentConfig['EnableAddress']) {
      setState(() {
        tabIndex = 1;
      });
      if (!kPaymentConfig['EnableShipping']) {
        setState(() {
          tabIndex = 2;
        });
        if (!kPaymentConfig['EnableReview']) {
          setState(() {
            tabIndex = 3;
            isPayment = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    Widget progressBar = Row(
      children: <Widget>[
        kPaymentConfig['EnableAddress']
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).address.toUpperCase(),
                          style: TextStyle(
                              color: tabIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      tabIndex >= 0
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2.0),
                                  bottomLeft: Radius.circular(2.0)),
                              child: Container(
                                  height: 3.0,
                                  color: Theme.of(context).primaryColor),
                            )
                          : Divider(
                              height: 2, color: Theme.of(context).accentColor)
                    ],
                  ),
                ),
              )
            : Container(),
        kPaymentConfig['EnableShipping']
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (cartModel.address != null &&
                        cartModel.address!.isValid()) {
                      setState(() {
                        tabIndex = 1;
                      });
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).shipping.toUpperCase(),
                          style: TextStyle(
                              color: tabIndex == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      tabIndex >= 1
                          ? Container(
                              height: 3.0,
                              color: Theme.of(context).primaryColor)
                          : Divider(
                              height: 2, color: Theme.of(context).accentColor)
                    ],
                  ),
                ),
              )
            : Container(),
        kPaymentConfig['EnableReview']
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (cartModel.shippingMethod != null) {
                      setState(() {
                        tabIndex = 2;
                      });
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).review.toUpperCase(),
                          style: TextStyle(
                            color: tabIndex == 2
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      tabIndex >= 2
                          ? Container(
                              height: 3.0,
                              color: Theme.of(context).primaryColor)
                          : Divider(
                              height: 2, color: Theme.of(context).accentColor)
                    ],
                  ),
                ),
              )
            : Container(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (cartModel.shippingMethod != null) {
                setState(() {
                  tabIndex = 3;
                });
              }
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    S.of(context).payment.toUpperCase(),
                    style: TextStyle(
                      color: tabIndex == 3
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                tabIndex >= 3
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(2.0),
                            bottomRight: Radius.circular(2.0)),
                        child: Container(
                            height: 3.0, color: Theme.of(context).primaryColor),
                      )
                    : Divider(height: 2, color: Theme.of(context).accentColor)
              ],
            ),
          ),
        )
      ],
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: const Text('עמוד קופה'),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    // my comment: while newOrder is not null > set to null (otherwise do nothing)
                    newOrder != null ? newOrder = null : null;
                  });
                  widget.controller!.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                  );
                  // Navigator.of(context).pop();
                }),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 3.0,
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: newOrder != null
                        ? OrderedSuccess(
                            order: newOrder,
                            isModal: widget.isModal,
                            controller: widget.controller,
                          )
                        : Column(
                            children: <Widget>[
                              //. !isPayment ? progressBar : Container(),
                              Expanded(
                                child: ListView(
                                  key: const Key('checkOutScreenListView'),
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  children: <Widget>[
                                    // renderContent(),

                                    ReviewScreen(
                                        // addressDetails: getAddressDetails,
                                        onBack: () {
                                      goToShippingTab(true);
                                    }, onNext: () {
                                      goToPaymentTab();
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.36),
                child: kLoadingWidget(context),
              )
            : Container()
      ],
    );
  }


  /// tabIndex: 0
  void goToAddressTab([bool isGoingBack = false]) {
    if (kPaymentConfig['EnableAddress']) {
      setState(() {
        tabIndex = 0;
      });
    } else {
      if (!isGoingBack) {
        goToShippingTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 1
  void goToShippingTab([bool isGoingBack = false]) {
    if (kPaymentConfig['EnableShipping']) {
      setState(() {
        tabIndex = 1;
      });
    } else {
      if (isGoingBack) {
        goToAddressTab(isGoingBack);
      } else {
        goToReviewTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 2
  void goToReviewTab([bool isGoingBack = false]) {
    if (kPaymentConfig['EnableReview'] ?? true) {
      setState(() {
        tabIndex = 2;
      });
    } else {
      if (isGoingBack) {
        goToShippingTab(isGoingBack);
      } else {
        goToPaymentTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 3
  void goToPaymentTab([bool isGoingBack = false]) {
    if (!isGoingBack) {
      setState(() {
        tabIndex = 3;
      });
    }
  }
}
