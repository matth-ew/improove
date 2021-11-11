import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:improove/redux/models/training.dart';

class CardRow extends StatelessWidget {
  final String? name;
  final String? category;
  final dynamic preview;
  final Function? onTap;
  final Widget? action;

  const CardRow({
    Key? key,
    this.name = '',
    this.category = '',
    this.preview,
    this.onTap,
    this.action,
  }) : super(key: key);

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
                    child: preview != null
                        ? preview is String
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const ColoredBox(color: Colors.grey),
                                imageUrl: preview!,
                                errorWidget: (context, url, error) =>
                                    const ColoredBox(color: Colors.grey),
                              )
                            : Image(
                                image: MemoryImage(preview),
                                fit: BoxFit.cover,
                              )
                        : const ColoredBox(color: Colors.grey),
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
                        name ?? "",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: textTheme.headline6
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category ?? "",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                            textTheme.bodyText2?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ),
      ),
    );
  }
}
