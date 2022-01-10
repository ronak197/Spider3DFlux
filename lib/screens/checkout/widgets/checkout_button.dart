import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fstore/screens/checkout/widgets/payment_methods.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/booking/booking_model.dart';
import '../../../models/index.dart'
    show
        AppModel,
        CartModel,
        Order,
        PaymentMethodModel,
        ShippingMethodModel,
        TaxModel,
        UserModel;
import '../../../modules/native_payment/index.dart';
import '../../../services/index.dart';
import '../checkout_screen.dart';
import '../review_screen.dart';

class CheckoutButton extends StatefulWidget {
  final Function? onBack;
  final Function? onFinish;
  final Function(bool)? onLoading;

  CheckoutButton({this.onBack, this.onFinish, this.onLoading});

  // const CheckoutButton({Key? key}) : super(key: key);

  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  var order_status = '';
  bool isPaying = false;
  var showCheckoutLoading = false;

  @override
  void initState() {
    super.initState();

    final cartModel = Provider.of<CartModel>(context, listen: false);
    Future.delayed(Duration.zero, () {
      final userModel = Provider.of<UserModel>(context, listen: false);
      final getPaymentMethods = Provider.of<PaymentMethodModel>(context,
              listen: false)
          .getPaymentMethods(
              cartModel: cartModel,
              shippingMethod: cartModel.shippingMethod,
              token: userModel.user != null ? userModel.user!.cookie : null);

      // My
      // final paymentMethodModel = Provider.of<PaymentMethodModel>(context, listen: false);

      // final paymentMethod = paymentMethodModel.paymentMethods.first;
      // Provider.of<CartModel>(context, listen: false).setPaymentMethod(paymentMethod);
      // print('4 Deafult paymentMethod.title');

      print(cartModel.paymentMethod?.title ??
          'Null = cartModel.paymentMethod?.title');

      if (kPaymentConfig['EnableReview'] != true) {
        Provider.of<TaxModel>(context, listen: false)
            .getTaxes(Provider.of<CartModel>(context, listen: false),
                (taxesTotal, taxes) {
          Provider.of<CartModel>(context, listen: false).taxesTotal =
              taxesTotal;
          Provider.of<CartModel>(context, listen: false).taxes = taxes;
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final taxModel = Provider.of<TaxModel>(context);

    return ButtonTheme(
      height: 45,
      // Processrocces order button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          onPrimary: Colors.white,
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // String? note = Provider.of<CartModel>(context, listen: false).notes ?? '';
          //   if (note.isNotEmpty && note != '') {Provider.of<CartModel>(context, listen: false).setOrderNotes(note);}

          // var cartModel = Provider.of<CartModel>(context);
          var addressModel = cartModel.address;
          var shipping_details_ready = false;
          var shipping_method_ready = false;
          var payment_details_ready = false;
          var payment_method_ready = false;

          order_status = '';
          var counter = 0;
          // if(ca){

          // print('Checking Shipping details:');
          if (addressModel!.firstName == null ||
          // region checkDetails
              addressModel.firstName == '' && addressModel.city == null ||
              addressModel.city == '' && addressModel.street == null ||
              addressModel.street == '' && addressModel.phoneNumber == null ||
              addressModel.phoneNumber == '' && addressModel.email == null ||
              addressModel.email == '') {
            print('>> Some Shipping details are missing.. <<');
            setState(() {
              counter += 1;
              order_status += '${counter.toString()}. ';
              order_status += 'הכנס פרטי משלוח \n';
            });
            print('order_status');
            print(order_status);
          } else {
            print('Full addressModel.toJson()');
            print(addressModel.toJson());
            shipping_details_ready = true;
          }

          // print('Checking shipping Method:');
          if (cartModel.shippingMethod == null ||
              cartModel.shippingMethod!.title == null ||
              cartModel.shippingMethod!.title == '') {
            print('>> Select A shipping method. <<');
            setState(() {
              counter += 1;
              order_status += '${counter.toString()}. ';
              order_status += 'בחר שיטת משלוח \n';
            });
            print('order_status');
            print(order_status);
          } else {
            print('cartModel.shippingMethod');
            print(cartModel.shippingMethod.runtimeType);
            print(cartModel.shippingMethod.runtimeType);
            print(cartModel.shippingMethod!.title);
            shipping_method_ready = true;
          }

          // print('Payment details:');
          if (addressModel.cardHolderName == null ||
              addressModel.cardHolderName == '' &&
                  addressModel.cardHolderId == null ||
              addressModel.cardHolderId == '' &&
                  addressModel.expiryDate == null ||
              addressModel.expiryDate == '' &&
                  addressModel.cardNumber == null ||
              addressModel.cardNumber == '' && addressModel.cvv == null ||
              addressModel.cvv == '') {
            print('>> Some Payment details are missing.. <<');
            setState(() {
              counter += 1;
              order_status += '${counter.toString()}. ';
              order_status += 'הכנס פרטי אשראי \n';
            });
            print('order_status');
            print(order_status);
          } else {
            payment_details_ready = true;
          }

          // print(cartModel.paymentMethod);
          // print('Payment Method:');
          // print(cartModel.paymentMethod!.title);

          // If Radio button Selected on screen but not on cartModel.paymentMethod
          if (cartModel.paymentMethod == null ||
              cartModel.paymentMethod?.title == null ||
              cartModel.paymentMethod?.title == '' &&
                  selectedPaymentId != null ||
              selectedPaymentId != '') {
            print(
                'Bug Fix! radioSelectionId is $selectedPaymentId But cartModel.paymentMethod is null!');
            if (paymentMethodModel.paymentMethods.isNotEmpty) {
              try {
                final paymentMethod = paymentMethodModel.paymentMethods
                    .firstWhere((item) => item.id == selectedPaymentId);
                Provider.of<CartModel>(context, listen: false)
                    .setPaymentMethod(paymentMethod);
              } catch (e, s) {
                print('WoOho: $e');
                // print(s);
              }

              print('Bug Fixed:');
              print('cartModel.paymentMethod');
              print(cartModel.paymentMethod?.title);
            }
          }

          if (cartModel.paymentMethod == null ||
              cartModel.paymentMethod!.title == null ||
              cartModel.paymentMethod!.title == ''
          ||
              selectedPaymentId == null ||
              selectedPaymentId == ''
          ) {
            print('>> Select A Payment method. <<');
            setState(() {
              counter += 1;
              order_status += '${counter.toString()}. ';
              order_status += 'בחר אמצעי תשלום \n';
            });
            print('cartModel.paymentMethod');
            print(cartModel.paymentMethod?.title);

            print('radioSelectionId');
            print(selectedPaymentId);

            print('order_status');
            print(order_status);
          } else {
            print('cartModel.paymentMethod');
            print(cartModel.paymentMethod?.title);

            payment_method_ready = true;
          }

          print('Order Notes:');
          print(cartModel.notes);

          print('selectedId:');
          print(selectedPaymentId);

          print('isPaying:');
          print(isPaying);
          // endregion checkDetails

          if (shipping_details_ready &&
              shipping_method_ready &&
              payment_details_ready &&
              payment_method_ready) {
            print('-------------\nEverything is ready!');

            // ORIGINAL PAYMENT REDIRECT
            setState(() {
              showCheckoutLoading = true;
            });

            // isPaying || selectedId == null ? showSnackbar :
            placeOrder(paymentMethodModel, cartModel);
          } else {
            print('-------------\nNot Everything is ready..');
            final snackBar = SnackBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              behavior: SnackBarBehavior.floating,
              // padding: const EdgeInsets.only(bottom: 15),
              backgroundColor: kColorSpiderRed.withOpacity(0.80),
              padding: const EdgeInsets.all(10),
              // content: Text(S.of(context).warning(message)),
              content: Text(
                '$order_status',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

              ),
              duration: Duration(seconds: order_status.length < 35 ? 4 : 6),
              action: SnackBarAction(
                label: S.of(context).close,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            );
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(snackBar);
          }

          // }

          // isPaying || selectedId == null
          //     ? showSnackbar
          //     : placeOrder(paymentMethodModel, cartModel);
        },
        child: const Text(
          'עבור לתשלום מאובטח',
          // S.of(context).placeMyOrder.toUpperCase()
        ),
      ),
    );
  }

  void showSnackbar() {
    Tools.showSnackBar(
        Scaffold.of(context), S.of(context).orderStatusProcessing);
  }

  void placeOrder(PaymentMethodModel paymentMethodModel, CartModel cartModel) {
    widget.onLoading!(true);
    isPaying = true;
    if (paymentMethodModel.paymentMethods.isNotEmpty) {
      final paymentMethod = paymentMethodModel.paymentMethods
          .firstWhere((item) => item.id == selectedPaymentId);

      Provider.of<CartModel>(context, listen: false)
          .setPaymentMethod(paymentMethod);

      /// Use Credit card. For Shopify only.
      if ((kPaymentConfig['EnableCreditCard'] ?? false) &&
          serverConfig['type'] == 'shopify') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreditCardPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading!(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true).then((value) {
                    widget.onLoading!(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );

        return;
      }

      /// Use Native payment

      /// Direct bank transfer (BACS)

      if (paymentMethod.id!.contains('bacs')) {
        widget.onLoading!(false);
        isPaying = false;

        showModalBottomSheet(
            context: context,
            builder: (sContext) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              S.of(context).cancel,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        paymentMethod.description!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const Expanded(child: SizedBox(height: 10)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onLoading!(true);
                          isPaying = true;
                          Services().widget.placeOrder(
                            context,
                            cartModel: cartModel,
                            onLoading: widget.onLoading,
                            paymentMethod: paymentMethod,
                            success: (Order order) async {
                              for (var item in order.lineItems) {
                                var product =
                                    cartModel.getProductById(item.productId!);
                                if (product?.bookingInfo != null) {
                                  product!.bookingInfo!.idOrder = order.id;
                                  var booking =
                                      await createBooking(product.bookingInfo)!;

                                  Tools.showSnackBar(
                                      Scaffold.of(context),
                                      booking
                                          ? 'Booking success!'
                                          : 'Booking error!');
                                }
                              }
                              widget.onFinish!(order);
                              widget.onLoading!(false);
                              isPaying = false;
                            },
                            error: (message) {
                              widget.onLoading!(false);
                              if (message != null) {
                                Tools.showSnackBar(
                                    Scaffold.of(context), message);
                              }
                              isPaying = false;
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          S.of(context).ok,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ));

        return;
      }

      /// PayPal Payment
      if (isNotBlank(PaypalConfig['paymentMethodId']) &&
          paymentMethod.id!.contains(PaypalConfig['paymentMethodId']) &&
          PaypalConfig['enabled'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading!(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true).then((value) {
                    widget.onLoading!(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );
        return;
      }

      /// Use WebView Payment per frameworks
      Services().widget.placeOrder(
        context,
        cartModel: cartModel,
        onLoading: widget.onLoading,
        paymentMethod: paymentMethod,
        success: (Order? order) async {
          if (order != null) {
            for (var item in order.lineItems) {
              var product = cartModel.getProductById(item.productId!);
              if (product?.bookingInfo != null) {
                product!.bookingInfo!.idOrder = order.id;
                var booking = await createBooking(product.bookingInfo)!;

                Tools.showSnackBar(Scaffold.of(context),
                    booking ? 'Booking success!' : 'Booking error!');
              }
            }
            widget.onFinish!(order);
          }
          widget.onLoading!(false);
          isPaying = false;
        },
        error: (message) {
          widget.onLoading!(false);
          if (message != null) {
            Tools.showSnackBar(Scaffold.of(context), message);
          }

          isPaying = false;
        },
      );
    }
  }

  Future<bool>? createBooking(BookingModel? bookingInfo) async {
    return Services().api.createBooking(bookingInfo)!;
  }

  Future<void> createOrder(
      {paid = false, bacs = false, cod = false, transactionId = ''}) async {
    widget.onLoading!(true);
    await Services().widget.createOrder(
      context,
      paid: paid,
      cod: cod,
      bacs: bacs,
      transactionId: transactionId,
      onLoading: widget.onLoading,
      success: (Order order) async {
        await Services()
            .api
            .updateOrderIdForRazorpay(transactionId, order.number);
        widget.onFinish!(order);
      },
      error: (message) {
        Tools.showSnackBar(Scaffold.of(context), message);
      },
    );
    widget.onLoading!(false);
  }
}
