import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/widgets/my_video_player.dart';
import 'package:intl/intl.dart';

class LocalVideoScreen extends StatefulWidget {
  final List<LocalVideo> videos;
  final int index;
  final Map<String, Uint8List?> thumbnails;
  const LocalVideoScreen({
    Key? key,
    required this.videos,
    required this.thumbnails,
    required this.index,
  }) : super(key: key);

  @override
  State<LocalVideoScreen> createState() => _LocalVideoScreenState();
}

class _LocalVideoScreenState extends State<LocalVideoScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            collapsedHeight: size.height * 0.38,
            expandedHeight: widget.videos.length > 1
                ? size.height * 0.78
                : size.height - MediaQuery.of(context).padding.top,
            flexibleSpace: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  top: Platform.isIOS ? 35 : 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // bottom: 25,
                  child: MyVideoPlayer(
                    video: File(widget.videos[currentIndex].path),
                    autoPlay: true,
                    key: Key(widget.videos[currentIndex].path),
                    // key: UniqueKey(),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: widget.videos.length > 1,
              child: Container(
                color: Colors.black,
                height: size.height * 0.22 - MediaQuery.of(context).padding.top,
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    bool selected = (currentIndex == index);
                    Uint8List? thumbnail =
                        widget.thumbnails[widget.videos[index].path];
                    String locale =
                        Localizations.localeOf(context).languageCode;
                    DateTime date =
                        File(widget.videos[index].path).lastModifiedSync();
                    String printDate = DateFormat.yMd(locale).format(date);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: index == widget.thumbnails.length - 1 ? 16 : 8,
                          top: selected ? 0 : 10,
                          bottom: selected ? 0 : 10,
                        ),
                        child: AspectRatio(
                          aspectRatio: 0.7,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              clipBehavior: Clip.none,
                              children: [
                                Visibility(
                                  visible: thumbnail != null,
                                  child: Image(
                                    image: MemoryImage(thumbnail!),
                                    fit: BoxFit.cover,
                                  ),
                                  replacement:
                                      const ColoredBox(color: Colors.grey),
                                ),
                                Visibility(
                                  visible: selected,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [0.6, 0.8, 1],
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.3)
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    printDate,
                                    style: textTheme.overline?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // Visibility(
                                //   visible: selected,
                                //   child: const Align(
                                //     child: Icon(
                                //       Icons.repeat,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.thumbnails.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
