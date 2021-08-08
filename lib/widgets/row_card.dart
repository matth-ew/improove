/// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:flutter/material.dart';
import 'package:improove/redux/models/training.dart';

const String previewPH = 'assets/images/undraw_pilates_gpdb.png';

class CardRow extends StatelessWidget {
  const CardRow({
    Key? key,
    required this.training,
    this.onTap,
  }) : super(key: key);

  final Training training;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: () => onTap?.call(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.28,
                child: AspectRatio(
                  aspectRatio: 1.54,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage(previewPH),
                      image: NetworkImage(training.preview),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        training.title,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: textTheme.headline6
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        training.category,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                            textTheme.bodyText2?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                color: Colors.grey,
                icon: const Icon(Icons.more_vert),
                splashRadius: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
