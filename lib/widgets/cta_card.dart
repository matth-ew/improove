/// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CtaCard extends StatelessWidget {
  final String name;
  final String duration;
  final String avatar;
  final String preview;
  const CtaCard(
      {Key? key,
      this.name = 'Nome video',
      this.duration = 'durata video',
      this.preview =
          'https://www.ispo.com/sites/default/files/styles/facebook/public/2020-04/Fitness%20App%20Training.jpg?h=1c9b88c9&itok=LpbSkBks',
      this.avatar = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    const widthScreenRatio = 198 / 254;
    const heightScreenRatio = 135 / 198;
    const radius = 15.0;
    // const borderSize = 2.0;

    //placeholders

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;

    // 254 620
    // 92 119 -> 198 135

    return SizedBox(
      height: heightCard,
      width: widthCard,
      child: Container(
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
    );
  }
}
