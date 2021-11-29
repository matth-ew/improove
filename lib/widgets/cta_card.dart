/// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CtaCard extends StatelessWidget {
  final String tag;
  final String preview;
  final Function? onPress;
  const CtaCard(
      {Key? key,
      this.onPress,
      this.tag = "",
      this.preview =
          'https://www.ispo.com/sites/default/files/styles/facebook/public/2020-04/Fitness%20App%20Training.jpg?h=1c9b88c9&itok=LpbSkBks'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // const double paddingBottomCategory = 2;
    // const double paddingRightCategory = 6;

    const widthScreenRatio = 198 / 254;
    const heightScreenRatio = 135 / 198;
    const radius = 15.0;
    // const borderSize = 2.0;

    //placeholders

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;

    // 254 620
    // 92 119 -> 198 135

    return GestureDetector(
      onTap: () {
        onPress?.call();
      },
      child: SizedBox(
        height: heightCard,
        width: widthCard,
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(radius)),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const ColoredBox(color: Colors.grey),
                    imageUrl: preview,
                    errorWidget: (context, url, error) =>
                        const ColoredBox(color: Colors.grey),
                  ),
                  // boxShadow: [
                  //   new BoxShadow(
                  //     color: Colors.black,
                  //     blurRadius: 2.0,
                  //   ),
                  // ],
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: () {
                    onPress?.call();
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(widthCard, 40)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        const StadiumBorder()),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tag,
                        style: textTheme.button?.copyWith(color: Colors.white),
                      ),
                      const Icon(Icons.arrow_right_alt, color: Colors.white),
                    ],
                  ),
                  // padding: const EdgeInsets.only(
                  //     top: 10, bottom: 10, left: 20, right: 20),
                  // backgroundColor: colorScheme.primary,
                  // label: Text(tag,
                  //     style: textTheme.headline6?.copyWith(color: Colors.white)),
                )),
          ],
        ),
      ),
    );
  }
}
