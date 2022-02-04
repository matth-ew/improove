import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:improove/screens/trainer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LongCard extends StatelessWidget {
  final String? name;
  final String? duration;
  final String? category;
  final String? avatar;
  final String? preview;
  final Function? onTapCard;
  final Function? onTapAvatar;
  final int? id;
  final int? trainerId;
  final double? widthRatio;
  final double? heightRatio;

  const LongCard({
    Key? key,
    this.name = '',
    this.duration = '',
    this.category,
    this.preview,
    this.avatar,
    this.id = -1,
    this.trainerId = -1,
    this.onTapCard,
    this.onTapAvatar,
    this.widthRatio,
    this.heightRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // final double hightScreen = MediaQuery.of(context).size.height;
    final double widthScreen = MediaQuery.of(context).size.width;

    final widthScreenRatio = widthRatio ?? 105 / 254;
    final heightScreenRatio = heightRatio ?? 119 / 92;
    const heightInnerScreenRatio = 20 / 99;
    const radiusAvatarRatio = 12 / 32;
    const paddingTopAvatarRatio = 88 / 119;
    const paddingLeftAvatarRatio = 9 / 92;
    const paddingTopTextRatio = 97 / 119;
    const paddingLeftTextRatio = 33 / 92;
    const radius = 15.0;
    const borderSize = 2.0;

    //placeholders

    final double widthCard = widthScreen * widthScreenRatio;
    final double heightCard = widthCard * heightScreenRatio;
    final double heightInnerCard = heightCard * heightInnerScreenRatio;
    final double radiusAvatar = heightInnerCard * radiusAvatarRatio;
    final double paddingTopAvatar =
        heightCard * paddingTopAvatarRatio - borderSize;
    final double paddingLeftAvatar =
        widthCard * paddingLeftAvatarRatio - borderSize;
    final double paddingTopText = heightCard * paddingTopTextRatio;
    final double paddingLeftText =
        paddingLeftAvatar + radiusAvatar * 2 + borderSize + 10;
    const double paddingTopCategory = 10;
    const double paddingLeftCategory = 10;

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
                child: preview != null && preview != ""
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) =>
                            ColoredBox(color: colorScheme.primary),
                        imageUrl: preview!,
                        errorWidget: (context, url, error) =>
                            ColoredBox(color: colorScheme.primary),
                      )
                    : const ColoredBox(color: Colors.grey),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      category!,
                      style: textTheme.caption?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                      name ?? "",
                      style: textTheme.subtitle2
                          ?.copyWith(color: colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(duration ?? "",
                        style: textTheme.bodyText2
                            ?.copyWith(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: paddingTopAvatar,
              left: paddingLeftAvatar,
              child: GestureDetector(
                onTap: () {
                  // pushNewScreen(
                  //   context,
                  //   screen: TrainerScreen(id: trainerId ?? -1),
                  //   withNavBar: true,
                  //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  // );
                },
                child: CircleAvatar(
                  radius: radiusAvatar + borderSize,
                  backgroundColor: colorScheme.background,
                  child: CircleAvatar(
                    radius: radiusAvatar,
                    backgroundImage: avatar != null && avatar != ""
                        ? CachedNetworkImageProvider(
                            avatar!,
                          )
                        : null,
                    backgroundColor: Colors.grey,
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
