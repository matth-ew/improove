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
      this.preview = '',
      this.avatar = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    const widthScreenRatio = 92 / 254;
    const heightScreenRatio = 135 / 92;
    const heightInnerScreenRatio = 36 / 135;
    const heightAvatarRatio = 20 / 32;
    const radius = 15.0;

    //placeholders
    const String previewPH = 'assets/images/undraw_pilates_gpdb.png';
    const String avatarPH = 'assets/images/meditation_bg.png';

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;
    final double heightInnerCard = heightCard * heightInnerScreenRatio;
    final double heightAvatar = heightInnerCard * heightAvatarRatio;

    // 254 620
    // 92 135
    // 85 36
    // 20 20

    return Container(
      height: heightCard,
      width: widthCard,
      child: Card(
        color: Colors.red,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Wrap(
          children: <Widget>[
            Container(
                height: heightCard - heightInnerCard - 8,
                width: widthCard,
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                  child: FadeInImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: AssetImage(previewPH),
                    image: NetworkImage(preview),
                  ),
                  // boxShadow: [
                  //   new BoxShadow(
                  //     color: Colors.black,
                  //     blurRadius: 2.0,
                  //   ),
                  // ],
                )),
            Container(
              height: heightInnerCard,
              width: widthCard,
              padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
              decoration: const BoxDecoration(
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
                            style: TextStyle(fontSize: 7, fontFamily: "mukta")),
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
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(radius)),
                      child: FadeInImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: AssetImage(avatarPH),
                        image: NetworkImage(avatar),
                      ),
                    ),
                    //  child: Icon(Icons.cake, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
