import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    Key? key,
    this.video = '',
    // this.onStart,
    this.onEnd,
  }) : super(key: key);

  final dynamic video;
  // final Function? onStart;
  final Function? onEnd;

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
    if (widget.video is String) {
      _videoPlayerController = VideoPlayerController.network(widget.video);
    } else {
      _videoPlayerController = VideoPlayerController.file(widget.video);
    }
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    if (widget.onEnd != null) {
      _videoPlayerController.addListener(() {
        if (!_videoPlayerController.value.isPlaying &&
            _videoPlayerController.value.isInitialized &&
            (_videoPlayerController.value.duration ==
                _videoPlayerController.value.position)) {
          //checking the duration and position every time
          //Video Completed//
          debugPrint("VIDEO FINITO");
          widget.onEnd?.call();
        }
      });
    }

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      // autoPlay: false,
      // looping: false,
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
