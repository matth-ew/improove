import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

enum CameraMode {
  photo,
  video,
}

class CameraScreen extends StatefulWidget {
  final Function? onSave;
  final CameraMode mode;
  const CameraScreen({
    Key? key,
    this.onSave,
    this.mode = CameraMode.video,
  }) : super(key: key);

  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String? message) {
  if (message != null) {
    debugPrint('Error: $code\nError Message: $message');
  } else {
    debugPrint('Error: $code');
  }
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  // late AnimationController _panoramaAnimationController;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  List<CameraDescription> cameras = [];
  Duration _elapsed = Duration.zero;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _initCameras();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });

    // _panoramaAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  _initCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      debugPrint(
          "UE INIT ${cameras.fold("", (previousValue, element) => "$previousValue ${element.toString()}")}");
      onNewCameraSelected(cameras.first);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    // _panoramaAnimationController.dispose();

    _ticker.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _modeControlRowWidget(),
            Expanded(
              child: Center(child: _cameraPreviewWidget()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _captureControlRowWidget(),
            ),
            // _cameraTogglesRowWidget(),
          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    return Visibility(
      visible: cameraController != null && cameraController.value.isInitialized,
      child: Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: Stack(
          children: [
            cameraController != null && cameraController.value.isInitialized
                ? CameraPreview(
                    controller!,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onScaleStart: _handleScaleStart,
                        onScaleUpdate: _handleScaleUpdate,
                        onTapDown: (details) =>
                            onViewFinderTap(details, constraints),
                      );
                    }),
                  )
                : const SizedBox.shrink(),
            Align(
              child: Visibility(
                visible: _elapsed.inSeconds > 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      "${_elapsed.inMinutes.toString().padLeft(2, '0')}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }
  // Stack(
  //         children: [
  //           CameraPreview(
  //             controller!,
  //             child: LayoutBuilder(
  //                 builder: (BuildContext context, BoxConstraints constraints) {
  //               return GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onScaleStart: _handleScaleStart,
  //                 onScaleUpdate: _handleScaleUpdate,
  //                 onTapDown: (details) => onViewFinderTap(details, constraints),
  //               );
  //             }),
  //           ),
  //           Align(
  //             child: Text(elapsed.toString()),
  //             alignment: Alignment.bottomCenter,
  //           ),
  //         ],
  //       ),

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  // Widget _thumbnailWidget() {
  //   final VideoPlayerController? localVideoController = videoController;

  //   return Expanded(
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           localVideoController == null && imageFile == null
  //               ? Container()
  //               : SizedBox(
  //                   child: (localVideoController == null)
  //                       ? (
  //                           // The captured image on the web contains a network-accessible URL
  //                           // pointing to a location within the browser. It may be displayed
  //                           // either with Image.network or Image.memory after loading the image
  //                           // bytes to memory.
  //                           kIsWeb
  //                               ? Image.network(imageFile!.path)
  //                               : Image.file(File(imageFile!.path)))
  //                       : Container(
  //                           child: Center(
  //                             child: AspectRatio(
  //                                 aspectRatio:
  //                                     localVideoController.value.size != null
  //                                         ? localVideoController
  //                                             .value.aspectRatio
  //                                         : 1.0,
  //                                 child: VideoPlayer(localVideoController)),
  //                           ),
  //                           decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.pink)),
  //                         ),
  //                   width: 64.0,
  //                   height: 64.0,
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const BackButton(color: Colors.white),
        IconButton(
          icon: const Icon(Icons.flash_on),
          onPressed: controller != null ? onFlashModeButtonPressed : null,
          color: Colors.white,
        ),
        // The exposure and focus mode are currently not supported on the web.
        ...(!kIsWeb
            ? [
                IconButton(
                  icon: const Icon(Icons.exposure),
                  color: Colors.white,
                  onPressed:
                      controller != null ? onExposureModeButtonPressed : null,
                ),
                IconButton(
                  icon: const Icon(Icons.filter_center_focus),
                  color: Colors.white,
                  onPressed:
                      controller != null ? onFocusModeButtonPressed : null,
                )
              ]
            : []),
        // IconButton(
        //   icon: Icon(enableAudio ? Icons.volume_up : Icons.volume_mute),
        //   onPressed: controller != null ? onAudioModeButtonPressed : null,
        // ),
        // IconButton(
        //   icon: Icon(controller?.value.isCaptureOrientationLocked ?? false
        //       ? Icons.screen_lock_rotation
        //       : Icons.screen_rotation),
        //   color: Colors.white,
        //   onPressed:
        //       controller != null ? onCaptureOrientationLockButtonPressed : null,
        // ),
        // _flashModeControlRowWidget(),
        // _exposureModeControlRowWidget(),
        // _focusModeControlRowWidget(),
      ],
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      primary: controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      primary: controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              const Center(
                child: const Text("Exposure Mode"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    child: const Text('AUTO'),
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                        showInSnackBar('Resetting exposure point');
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('LOCKED'),
                    style: styleLocked,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                  ),
                  TextButton(
                    child: const Text('RESET OFFSET'),
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => controller!.setExposureOffset(0.0)
                        : null,
                  ),
                ],
              ),
              const Center(
                child: Text("Exposure Offset"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(_minAvailableExposureOffset.toString()),
                  Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                            _maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(_maxAvailableExposureOffset.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      primary: controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      primary: controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              const Center(
                child: Text("Focus Mode"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    child: const Text('AUTO'),
                    style: styleAuto,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) controller!.setFocusPoint(null);
                      showInSnackBar('Resetting focus point');
                    },
                  ),
                  TextButton(
                    child: const Text('LOCKED'),
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // Visibility(
        //   visible: widget.mode == CameraMode.photo,
        //   child: IconButton(
        //     icon: const Icon(Icons.camera_alt),
        //     color: Colors.blue,
        //     onPressed: cameraController != null &&
        //             cameraController.value.isInitialized &&
        //             !cameraController.value.isRecordingVideo
        //         ? onTakePictureButtonPressed
        //         : null,
        //   ),
        // ),
        // Visibility(
        //   visible: widget.mode == CameraMode.video,
        //   child: IconButton(
        //     icon: const Icon(Icons.videocam),
        //     color: Colors.blue,
        //     onPressed: cameraController != null &&
        //             cameraController.value.isInitialized &&
        //             !cameraController.value.isRecordingVideo
        //         ? onVideoRecordButtonPressed
        //         : null,
        //   ),
        // ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: cameras.length > 2,
          child: IconButton(
            icon: const Icon(Icons.panorama_horizontal_rounded),
            // progress: _panoramaAnimationController,
            color: Colors.white,
            iconSize: 45,
            onPressed: controller != null ? switchAngle : null,
          ),
        ),
        RawMaterialButton(
          onPressed:
              cameraController != null && cameraController.value.isInitialized
                  ? widget.mode == CameraMode.video
                      ? !cameraController.value.isRecordingVideo
                          ? onVideoRecordButtonPressed
                          : onStopButtonPressed
                      : onTakePictureButtonPressed
                  : null,
          elevation: 2.0,
          fillColor: Colors.white,
          child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: cameraController != null &&
                cameraController.value.isInitialized &&
                cameraController.value.isRecordingVideo,
            child: const Icon(
              Icons.stop,
              size: 35,
              color: Colors.black,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
        ),
        // IconButton(
        //   iconSize: 35,
        //   icon: cameraController != null &&
        //           cameraController.value.isRecordingPaused
        //       ? const Icon(Icons.play_arrow)
        //       : const Icon(Icons.pause),
        //   color: Colors.blue,
        //   onPressed: cameraController != null &&
        //           cameraController.value.isInitialized &&
        //           cameraController.value.isRecordingVideo
        //       ? (cameraController.value.isRecordingPaused)
        //           ? onResumeButtonPressed
        //           : onPauseButtonPressed
        //       : null,
        // ),
        IconButton(
          icon: const Icon(Icons.flip_camera_android_rounded),
          color: Colors.white,
          iconSize: 45,
          onPressed: controller != null ? switchDirection : null,
        ),
        // IconButton(
        //   icon: const Icon(Icons.pause_presentation),
        //   color:
        //       cameraController != null && cameraController.value.isPreviewPaused
        //           ? Colors.red
        //           : Colors.blue,
        //   onPressed:
        //       cameraController == null ? null : onPausePreviewButtonPressed,
        // ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    final onChanged = (CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    };

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(
                getCameraLensIcon(cameraDescription.lensDirection),
                color: Colors.white,
              ),
              groupValue: controller?.description,
              value: cameraDescription,
              activeColor: Colors.white,
              onChanged:
                  controller != null && controller!.value.isRecordingVideo
                      ? null
                      : onChanged,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void switchDirection() {
    if (controller == null) {
      return;
    }
    CameraLensDirection? oldDirection = controller?.description.lensDirection;
    debugPrint("UE OLD ${controller?.description}");
    if (cameras.isNotEmpty) {
      onNewCameraSelected(cameras.firstWhere(
        (e) => e.lensDirection != oldDirection,
        orElse: () => cameras.first,
      ));
    }
  }

  void switchAngle() {
    if (controller == null) {
      return;
    }
    CameraDescription? oldCamera = controller?.description;
    debugPrint("UE OLD ${controller?.description}");
    if (cameras.isNotEmpty) {
      onNewCameraSelected(
        cameras.firstWhere(
          (e) => (e.lensDirection == oldCamera?.lensDirection &&
              e.name != oldCamera?.name),
          orElse: () => cameras.first,
        ),
      );
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      // kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      ResolutionPreset.max,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        // The exposure mode is currently not supported on the web.
        ...(!kIsWeb
            ? [
                cameraController
                    .getMinExposureOffset()
                    .then((value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((value) => _maxAvailableExposureOffset = value)
              ]
            : []),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) showInSnackBar('Picture saved to ${file.path}');
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  // void onAudioModeButtonPressed() {
  //   enableAudio = !enableAudio;
  //   if (controller != null) {
  //     onNewCameraSelected(controller!.description);
  //   }
  // }

  void onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      _ticker.start();
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    _ticker.stop();
    stopVideoRecording().then((file) {
      _elapsed = Duration.zero;
      if (mounted) setState(() {});
      if (file != null) {
        widget.onSave?.call(file);
        // showInSnackBar('Video recorded to ${file.path}');
        // videoFile = file;
        // _startVideoPlayer();
      }
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) setState(() {});
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController = kIsWeb
        ? VideoPlayerController.network(videoFile!.path)
        : VideoPlayerController.file(File(videoFile!.path));

    videoPlayerListener = () {
      if (videoController != null && videoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
// TODO(ianh): Remove this once we roll stable in late 2021.
T? _ambiguate<T>(T? value) => value;

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint();
    paint1..color = Colors.red;
    paint1..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(35 / 2, 35 / 2), size.width / 2, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
