import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:improove/data.dart';
import 'package:video_player/video_player.dart';

class ProgressionScreen extends StatelessWidget {
  final String id;
  const ProgressionScreen({
    Key? key,
    this.id = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String video =
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
    //https: //assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4;
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            collapsedHeight: size.height * 0.38,
            expandedHeight: size.height * 0.58,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 32,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 35,
                  child: MyVideoPlayer(video: video),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 35,
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
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 15.0,
                  ),
                  child: Text(
                    "How to Perform",
                    style: textTheme.headline6
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 15.0,
                  ),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess",
                    expandText: "expand",
                    collapseText: "collapse",
                    linkColor: colorScheme.primary,
                    maxLines: 3,
                    style: textTheme.bodyText2
                        ?.copyWith(color: colorScheme.primary.withOpacity(.59)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    "Common Mistakes",
                    style: textTheme.headline6
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 15.0,
                  ),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess",
                    expandText: "expand",
                    collapseText: "collapse",
                    linkColor: colorScheme.primary,
                    maxLines: 3,
                    style: textTheme.bodyText2
                        ?.copyWith(color: colorScheme.primary.withOpacity(.59)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    "Tips",
                    style: textTheme.headline6
                        ?.copyWith(color: colorScheme.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 5.0,
                  ),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit ess",
                    expandText: "expand",
                    collapseText: "collapse",
                    linkColor: colorScheme.primary,
                    maxLines: 3,
                    style: textTheme.bodyText2
                        ?.copyWith(color: colorScheme.primary.withOpacity(.59)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    Key? key,
    this.video = '',
  }) : super(key: key);

  final String video;

  @override
  State<StatefulWidget> createState() {
    return _MyVideoPlayerState();
  }
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.video);
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        //   handleColor: Colors.blue,
        // backgroundColor: Colors.black,
        //   bufferedColor: Colors.lightGreen,
      ),
      // placeholder: Container(
      // color: Colors.black,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20),
                        Text('Loading', style: TextStyle(color: Colors.white)),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
