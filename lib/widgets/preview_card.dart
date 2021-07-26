/// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:flutter/material.dart';
import '../screens/training_screen.dart';

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
    const heightScreenRatio = 119 / 92;
    const heightInnerScreenRatio = 20 / 99;
    const heightAvatarRatio = 24 / 32;
    const paddingTopAvatarRatio = 88 / 119;
    const paddingLeftAvatarRatio = 9 / 92;
    const paddingTopTextRatio = 103 / 119;
    const paddingLeftTextRatio = 33 / 92;
    const radius = 15.0;
    const borderSize = 2.0;

    //placeholders
    const String previewPH = 'assets/images/undraw_pilates_gpdb.png';
    const String avatarPH = 'assets/images/meditation_bg.png';

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;
    final double heightInnerCard = heightCard * heightInnerScreenRatio;
    final double heightAvatar = heightInnerCard * heightAvatarRatio;
    final double paddingTopAvatar =
        heightCard * paddingTopAvatarRatio - borderSize;
    final double paddingLeftAvatar =
        widthCard * paddingLeftAvatarRatio - borderSize;
    final double paddingTopText = heightCard * paddingTopTextRatio;
    final double paddingLeftText = widthCard * paddingLeftTextRatio;

    // 254 620
    // 92 119
    // 92 99
    // 22 22
    // 88 9 padding avatar
    // 103 33 padding text

    return SizedBox(
        height: heightCard,
        width: widthCard,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingScreen()),
            );
          },
          child: Stack(children: <Widget>[
            Container(
                height: heightCard - heightInnerCard,
                width: widthCard,
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(radius)),
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
            Positioned(
              top: paddingTopText,
              left: paddingLeftText,
              child: SizedBox(
                height: heightInnerCard,
                width: widthCard,
                child: Column(
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
            ),
            Positioned(
              top: paddingTopAvatar,
              left: paddingLeftAvatar,
              child: SizedBox(
                width: heightAvatar + borderSize,
                height: heightAvatar + borderSize,
                child: ClipRRect(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                    border: Border.all(
                      color: Colors.white,
                      width: borderSize,
                    ),
                  ),
                  child: ClipOval(
                    child: FadeInImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AssetImage(avatarPH),
                      image: NetworkImage(avatar),
                    ),
                  ),
                )),
              ),
            ),
          ]),
        ));
  }
}
