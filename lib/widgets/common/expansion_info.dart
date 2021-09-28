import 'package:flutter/material.dart';

import 'expansion_tile.dart';
import 'dart:math' as math; // import this

class ExpansionInfo extends StatelessWidget {
  final String title;
  final bool expand;
  final List<Widget> children;

  ExpansionInfo(
      {required this.title, required this.children, this.expand = false});

  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      initiallyExpanded: expand,
      bottomBorderOn: false,
      topBorderOn: false,
      headerExpanded: Flexible(
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Transform(
                    transform: Matrix4.rotationY(math.pi),
                    origin: const Offset(12, 0),
                    child: Icon(
                      Icons.local_shipping,
                      // color: Theme.of(context).accentColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  ),
                ])),
      ),
      header: Flexible(
        child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  )
                ])),
      ),
      children: children,
    );
  }
}
