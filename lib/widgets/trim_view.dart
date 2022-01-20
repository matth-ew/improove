import 'dart:io';
import 'package:flutter/material.dart';
import 'trimmer/video_trimmer.dart';
import 'trimmer/trimmer.dart';
import 'trimmer/video_viewer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isMute = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        ffmpegCommand: _isMute ? '-y -c copy -an' : null,
        customVideoFormat: ".mp4",
        storageDir: StorageDir.applicationDocumentsDirectory,
        videoFolderName: "VideoSalvati",
        videoFileName: uuid.v1(),
        onSave: (value) {
          widget.onSave?.call(value);
          setState(() {
            _progressVisibility = false;
            _value = value;
          });
          Navigator.pop(context);
        });

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

  showPopDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.wantDeleteVideo),
              content: Text(AppLocalizations.of(context)!.backLoseVideo),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.no),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        showPopDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              splashRadius: 20,
              icon: _isMute
                  ? const Icon(Icons.volume_off)
                  : const Icon(Icons.volume_up_rounded),
              onPressed: () {
                bool value = !_isMute;
                setState(() {
                  _isMute = value;
                });
                _trimmer.videoPlayerController?.setVolume(value ? 0.0 : 1.0);
              },
            ),
          ],
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
                      circleSize: 8,
                      circleSizeOnDrag: 10,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).maybePop();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.delete_forever_rounded,
                                  color: Colors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.discard,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _progressVisibility
                              ? null
                              : () async {
                                  _saveVideo();
                                },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.save_alt_rounded),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(AppLocalizations.of(context)!.save),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
