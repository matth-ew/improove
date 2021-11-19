import 'dart:io';
import 'package:flutter/material.dart';
import 'trimmer/video_trimmer.dart';
import 'trimmer/trimmer.dart';
import 'trimmer/video_viewer.dart';
import 'package:uuid/uuid.dart';

class TrimmerView extends StatefulWidget {
  final File file;
  final Function? onSave;

  const TrimmerView(this.file, {Key? key, this.onSave}) : super(key: key);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();
  var uuid = const Uuid();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            storageDir: "applicationDocumentsDirectory",
            videoFolderName: "VideoSalvati",
            videoFileName: uuid.v1())
        .then(
      (value) {
        widget.onSave?.call(value);
        setState(() {
          _progressVisibility = false;
          _value = value;
        });
      },
    );

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      bool playbackState = await _trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                    child: Stack(
                      children: [
                        VideoViewer(trimmer: _trimmer),
                        Visibility(
                          visible: !_isPlaying,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 80.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: TrimEditor(
                    sideTapSize: 50,
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width * 0.9,
                    // maxVideoLength: Duration(seconds: 10),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            debugPrint('OUTPUT PATH: $outputPath');
                            const snackBar = SnackBar(
                                content: Text('Video Saved successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );
                          });
                        },
                  child: const Text("SAVE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
