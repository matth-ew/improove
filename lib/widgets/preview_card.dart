/// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:flutter/material.dart';

class PreviewCard extends StatelessWidget {
  final String name;
  final String duration;
  final String avatar;
  final String preview;
  const PreviewCard(
      {Key? key,
      this.name = 'Nome video',
      this.duration = 'durata video',
      this.preview = 'assets/images/undraw_pilates_gpdb.png',
      this.avatar = 'assets/images/meditation_bg.png'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    const widthScreenRatio = 92 / 254;
    const heightScreenRatio = 135 / 92;
    const heightInnerScreenRatio = 36 / 135;
    const heightAvatarRatio = 20 / 32;
    const radius = 12.0;

    double widhtCard = widthScreen * widthScreenRatio;
    double heightCard = widhtCard * heightScreenRatio;
    double heightInnerCard = heightCard * heightInnerScreenRatio;
    double heightAvatar = heightInnerCard * heightAvatarRatio;

    // 254 620
    // 92 135
    // 85 36
    // 20 20

    return SizedBox(
        height: heightCard,
        width: widhtCard,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                    height: heightCard - heightInnerCard - 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                      image: DecorationImage(
                        image: AssetImage(preview),
                        fit: BoxFit.cover,
                      ),
                      // boxShadow: [
                      //   new BoxShadow(
                      //     color: Colors.black,
                      //     blurRadius: 2.0,
                      //   ),
                      // ],
                    ),
                    alignment: Alignment.bottomCenter),
                Container(
                  height: heightInnerCard,
                  padding: EdgeInsets.fromLTRB(10, 6, 6, 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          bottomRight: Radius.circular(radius))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(name,
                                style: TextStyle(
                                    fontSize: 7, fontFamily: "mukta")),
                            Text(duration,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 5,
                                    fontFamily: "mukta")),
                          ],
                        ),
                      ),
                      Container(
                          width: heightAvatar,
                          height: heightAvatar,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius)),
                            image: DecorationImage(
                              image: AssetImage(avatar),
                              fit: BoxFit.cover,
                            ),
                          )
                          //  child: Icon(Icons.cake, color: Colors.white),
                          ),
                    ],
                  ),
                )
              ],
            )));
  }
}
