import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    Key? key,
    this.video = '',
    this.autoPlay = false,
    // this.onStart,
    this.onEnd,
  }) : super(key: key);

  final dynamic video;
  final bool autoPlay;
  // final Function? onStart;
  final Function? onEnd;

  @override
  State<StatefulWidget> createState() {
    return _MyVideoPlayerState();
  }
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    try {
      if (widget.video is String) {
        _videoPlayerController = VideoPlayerController.network(widget.video);
      } else {
        _videoPlayerController = VideoPlayerController.file(widget.video);
      }
      await _videoPlayerController?.initialize();
      if (widget.onEnd != null) {
        _videoPlayerController?.addListener(() {
          if (_videoPlayerController?.value.isPlaying == false &&
              _videoPlayerController?.value.isInitialized == true &&
              (_videoPlayerController?.value.duration != null) &&
              (_videoPlayerController?.value.duration ==
                  _videoPlayerController?.value.position)) {
            //checking the duration and position every time
            //Video Completed//
            debugPrint("VIDEO FINITO");
            widget.onEnd?.call();
          }
        });
      }

      _createChewieController();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _createChewieController() {
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: widget.autoPlay,
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
    });
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
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context)!.loading,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
