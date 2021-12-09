import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:improove/redux/models/local_video.dart';
import 'package:improove/widgets/my_video_player.dart';

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
    // final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
                    key: UniqueKey(),
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
                    Uint8List? thumbnail =
                        widget.thumbnails[widget.videos[index].path];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: index == widget.thumbnails.length - 1 ? 16 : 8,
                        ),
                        child: AspectRatio(
                          aspectRatio: 0.7,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: thumbnail != null
                                ? Image(
                                    image: MemoryImage(thumbnail),
                                    fit: BoxFit.cover,
                                  )
                                : const ColoredBox(color: Colors.grey),
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
