import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:improove/screens/profile_screen.dart';

class PreviewCard extends StatelessWidget {
  final String name;
  final String duration;
  final String? category;
  final String? avatar;
  final String? preview;
  final Function? onTapCard;
  final Function? onTapAvatar;
  final int? id;

  const PreviewCard({
    Key? key,
    this.name = 'Nome video',
    this.duration = 'durata video',
    this.category,
    this.preview,
    this.avatar,
    this.id = -1,
    this.onTapCard,
    this.onTapAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    const widthScreenRatio = 105 / 254;
    const heightScreenRatio = 119 / 92;
    const heightInnerScreenRatio = 20 / 99;
    const radiusAvatarRatio = 12 / 32;
    const paddingTopAvatarRatio = 88 / 119;
    const paddingLeftAvatarRatio = 9 / 92;
    const paddingTopTextRatio = 97 / 119;
    const paddingLeftTextRatio = 33 / 92;
    const radius = 15.0;
    const borderSize = 2.0;

    //placeholders
    const String previewPH = 'assets/images/undraw_pilates_gpdb.png';
    // const String avatarPH = 'assets/images/meditation_bg.png';

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;
    final double heightInnerCard = heightCard * heightInnerScreenRatio;
    final double radiusAvatar = heightInnerCard * radiusAvatarRatio;
    final double paddingTopAvatar =
        heightCard * paddingTopAvatarRatio - borderSize;
    final double paddingLeftAvatar =
        widthCard * paddingLeftAvatarRatio - borderSize;
    final double paddingTopText = heightCard * paddingTopTextRatio;
    final double paddingLeftText = widthCard * paddingLeftTextRatio;
    const double paddingTopCategory = 2;
    const double paddingLeftCategory = 6;

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
          onTapCard?.call(id);
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: heightCard - heightInnerCard,
              width: widthCard,
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(radius)),
                child: preview != null
                    ? FadeInImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(previewPH),
                        image: NetworkImage(preview!),
                      )
                    : Image.asset(previewPH),
                // boxShadow: [
                //   new BoxShadow(
                //     color: Colors.black,
                //     blurRadius: 2.0,
                //   ),
                // ],
              ),
            ),
            if (category != null)
              Positioned(
                top: paddingTopCategory,
                left: paddingLeftCategory,
                child: Chip(
                  backgroundColor: colorScheme.primary,
                  label: Text(category!,
                      style:
                          textTheme.bodyText2?.copyWith(color: Colors.white)),
                ),
              ),
            Positioned(
              top: paddingTopText,
              left: avatar != null ? paddingLeftText : paddingLeftAvatar,
              child: SizedBox(
                height: heightInnerCard,
                width: widthCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: textTheme.subtitle2
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    Text(duration,
                        style: textTheme.bodyText2
                            ?.copyWith(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            if (avatar != null)
              Positioned(
                top: paddingTopAvatar,
                left: paddingLeftAvatar,
                child: GestureDetector(
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: ProfileScreen(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: CircleAvatar(
                    radius: radiusAvatar + borderSize,
                    backgroundColor: colorScheme.background,
                    child: CircleAvatar(
                      radius: radiusAvatar,
                      backgroundImage: NetworkImage(avatar!),
                      backgroundColor: Colors.transparent,
                      // FadeInImage(
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      //   placeholder: AssetImage(avatarPH),
                      //   image: NetworkImage(avatar),
                      // ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
