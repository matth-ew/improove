import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:improove/widgets/my_video_player.dart';

class LocalVideoScreen extends StatelessWidget {
  final File video;
  final List<Uint8List?> thumbnails;
  const LocalVideoScreen({
    Key? key,
    required this.video,
    required this.thumbnails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            collapsedHeight: size.height * 0.38,
            expandedHeight: size.height * 0.58,
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back),
            //   iconSize: 32,
            //   color: Colors.white,
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
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
                  bottom: 25,
                  child: MyVideoPlayer(
                    video: video,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 25,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Image(
                  image: MemoryImage(thumbnails[0]!),
                  fit: BoxFit.cover,
                );
              },
              childCount: thumbnails.length,
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      // ),
      // backgroundColor: Colors.black,
      // body: MyVideoPlayer(
      //   video: video,
      // ),
    );
  }
}
