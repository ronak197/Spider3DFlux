import 'package:flutter/material.dart';
import 'package:fstore/widgets/product/dialog_add_to_cart.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, CartModel, Product, ProductVariation;
import '../../../routes/flux_navigate.dart';

enum SimpleListType { BackgroundColor, PriceOnTheRight }

class SimpleListView extends StatelessWidget {
  final Product? item;
  final SimpleListType? type;

  const SimpleListView({this.item, this.type});

  @override
  Widget build(BuildContext context) {
    if (item?.name == null) return const SizedBox();

    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleFontSize = 15.0;
    var imageWidth = 60.0;
    var imageHeight = 60.0;

    final theme = Theme.of(context);

    var isSale = (item!.onSale ?? false) &&
        PriceTools.getPriceProductValue(item, currency, onSale: true) !=
            PriceTools.getPriceProductValue(item, currency, onSale: false);
    if (item!.type == 'variable') {
      isSale = item!.onSale ?? false;
    }

    var priceProduct = PriceTools.getPriceProductValue(
      item,
      currency,
      onSale: true,
    );

    void onTapProduct() {
      print(item);
      if (item!.imageFeature == '') return;
      FluxNavigate.pushNamed(
        RouteList.productDetail,
        arguments: item,
      );
    }

    /// Product Pricing
    Widget _productPricing = Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: <Widget>[
        Text(
          item!.type == 'grouped'
              ? '${S.of(context).from} ${PriceTools.getPriceProduct(item, currencyRate, currency, onSale: true)}'
              : priceProduct == '0.0'
                  ? S.of(context).loading
                  : PriceTools.getPriceProduct(item, currencyRate, currency,
                      onSale: true)!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 15,
                color: theme.accentColor,
              ),
        ),
        if (isSale) ...[
          const SizedBox(width: 5),
          Text(
            item!.type == 'grouped'
                ? ''
                : PriceTools.getPriceProduct(item, currencyRate, currency,
                    onSale: false)!,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).accentColor.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough,
                ),
          ),
        ]
      ],
    );

    void addToCart(BuildContext context) {
      final String Function(
          {dynamic context,
          dynamic isSaveLocal,
          Function notify,
          Map<String, dynamic> options,
          Product? product,
          int quantity,
          ProductVariation variation}) addProductToCart =
          Provider.of<CartModel>(context, listen: false).addProductToCart;
          DialogAddToCart.show(context, product: item!);
    }

    /// Show Cart button
    /// width on product page = 120, on main page = 180 (180 / 9 = 120 | 120 / 9 = 13)
    var myRadiusBasedWidth = 18.0;
    Widget _showCart = CircleAvatar(
      // backgroundColor: Colors.white.withOpacity(0.3),
      backgroundColor: Colors.grey.withOpacity(0.07),
      // radius: 20, // Original
      radius: myRadiusBasedWidth,
      child: IconButton(
          color: Theme.of(context).accentColor.withOpacity(0.5),
          // color: Colors.black,
          // icon: Icon(Icons.add_shopping_cart, size: width! / 10 * 1.3),
          icon: const Icon(Icons.add_shopping_cart, size: 18),
          onPressed: () => addToCart(context)),

    );


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: onTapProduct,
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: type == SimpleListType.BackgroundColor
                ? Theme.of(context).primaryColorLight
                : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: ImageTools.image(
                    url: item!.imageFeature,
                    width: imageWidth,
                    size: kSize.medium,
                    isResize: true,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item!.name!,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      (type != SimpleListType.PriceOnTheRight)
                          ? _productPricing
                          : Container(),
                    ],
                  ),
                ),
                (type == SimpleListType.PriceOnTheRight)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: _productPricing,
                      )
                    : Container(),
                _showCart
              ],
            ),
          ),
        ),
      ),
    );
  }
}
