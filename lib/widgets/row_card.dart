import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:improove/redux/models/training.dart';

class RowCard extends StatelessWidget {
  final String? imageText;
  final Color? imageBg;
  final String? name;
  final String? category;
  final dynamic preview;
  final Function? onTap;
  final int? maxLines;
  final List<Widget>? actions;
  final bool locked;

  const RowCard({
    Key? key,
    this.name = '',
    this.category = '',
    this.imageText,
    this.imageBg,
    this.preview,
    this.onTap,
    this.maxLines,
    this.actions,
    this.locked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        color: locked ? Colors.grey[100] : colorScheme.background,
        child: InkWell(
          // borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: () => onTap?.call(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.23,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.54,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: preview != null
                              ? preview is String
                                  ? (preview as String).contains("http")
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const ColoredBox(
                                                  color: Colors.grey),
                                          imageUrl: preview!,
                                          errorWidget: (context, url, error) =>
                                              const ColoredBox(
                                                  color: Colors.grey),
                                        )
                                      : Image(
                                          image: FileImage(File(preview)),
                                          fit: BoxFit.cover,
                                        )
                                  : Image(
                                      image: MemoryImage(preview),
                                      fit: BoxFit.cover,
                                    )
                              : Container(
                                  color: imageBg ?? Colors.grey,
                                  child: imageText != null
                                      ? FittedBox(
                                          child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(imageText!),
                                        ))
                                      : null),
                        ),
                      ),
                      Visibility(
                        visible: locked,
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: name != null && name!.isNotEmpty,
                          child: Text(
                            name ?? "",
                            textAlign: TextAlign.left,
                            maxLines: maxLines,
                            style: textTheme.subtitle1?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                            visible: category != null && category!.isNotEmpty,
                            child: const SizedBox(height: 5)),
                        Visibility(
                          visible: category != null && category!.isNotEmpty,
                          child: Text(
                            category ?? "",
                            textAlign: TextAlign.left,
                            // maxLines: 3,
                            style: textTheme.caption?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...?actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
