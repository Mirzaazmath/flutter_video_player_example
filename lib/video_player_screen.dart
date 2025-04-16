import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];
  bool isFullScreen = false;
  bool _showDoubleTapIconForward = false;
  bool _showDoubleTapIconBackward = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void setOrientation() {
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen ? null : AppBar(title: Text("Video Player")),
      body: Column(
        children: [
          _videoPlayerController.value.isInitialized
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height:
                        isFullScreen
                            ? MediaQuery.sizeOf(context).height
                            : MediaQuery.sizeOf(context).height * 0.3,
                    width: double.infinity,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onDoubleTap: () async {
                            final currentPosition =
                                await _videoPlayerController.position;
                            if (currentPosition != null) {
                              final newPosition =
                                  currentPosition - const Duration(seconds: 10);
                              final duration =
                                  _videoPlayerController.value.duration;

                              // Make sure it doesn't go beyond the total video length
                              if (newPosition < duration) {
                                _videoPlayerController.seekTo(newPosition);
                              } else {
                                _videoPlayerController.seekTo(duration);
                              }
                            }
                            // Show splash icon
                            setState(() => _showDoubleTapIconBackward = true);
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            setState(() => _showDoubleTapIconBackward = false);
                          },
                          child: Container(
                            height:
                                isFullScreen
                                    ? MediaQuery.sizeOf(context).height
                                    : MediaQuery.sizeOf(context).height * 0.3,
                            decoration: BoxDecoration(
                              // color:_showDoubleTapIconBackward? Colors.black38:Colors.transparent,
                              gradient: LinearGradient(
                                colors:
                                    _showDoubleTapIconBackward
                                        ? [
                                          Colors.black54,
                                          Colors.black38,
                                          Colors.transparent,
                                        ]
                                        : [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                              ),
                            ),
                            child:
                                _showDoubleTapIconBackward
                                    ? Icon(
                                      Icons.fast_rewind,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                    : SizedBox(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onDoubleTap: () async {
                            final currentPosition =
                                await _videoPlayerController.position;
                            if (currentPosition != null) {
                              final newPosition =
                                  currentPosition + const Duration(seconds: 10);
                              final duration =
                                  _videoPlayerController.value.duration;

                              // Make sure it doesn't go beyond the total video length
                              if (newPosition < duration) {
                                _videoPlayerController.seekTo(newPosition);
                              } else {
                                _videoPlayerController.seekTo(duration);
                              }
                            }
                            // Show splash icon
                            setState(() => _showDoubleTapIconForward = true);
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            setState(() => _showDoubleTapIconForward = false);
                          },
                          child: Container(

                            height:
                                isFullScreen
                                    ? MediaQuery.sizeOf(context).height
                                    : MediaQuery.sizeOf(context).height * 0.3,
                            decoration: BoxDecoration(
                              // color:_showDoubleTapIconForward? Colors.black38:Colors.transparent,
                              gradient: LinearGradient(
                                colors:
                                    _showDoubleTapIconForward
                                        ? [
                                          Colors.transparent,

                                          Colors.black38,
                                          Colors.black54,
                                        ]
                                        : [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                              ),
                            ),
                            child:
                                _showDoubleTapIconForward
                                    ? Icon(
                                      Icons.fast_forward,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                    : SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isFullScreen
                      ? Positioned(
                        left: 0,
                        top: 0,
                        child: SafeArea(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                      : SizedBox(),
                  Padding(
                    padding:
                        isFullScreen
                            ? const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            )
                            : EdgeInsets.zero,
                    child: Column(
                      children: [
                        VideoProgressIndicator(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          _videoPlayerController,
                          allowScrubbing: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _videoPlayerController.value.isPlaying
                                          ? _videoPlayerController.pause()
                                          : _videoPlayerController.play();
                                    });
                                  },
                                  icon: Icon(
                                    _videoPlayerController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton<double>(
                              initialValue:
                                  _videoPlayerController.value.playbackSpeed,
                              tooltip: 'Playback speed',
                              onSelected: (double speed) {
                                setState(() {
                                  _videoPlayerController.setPlaybackSpeed(
                                    speed,
                                  );
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuItem<double>>[
                                  for (final double speed
                                      in _examplePlaybackRates)
                                    PopupMenuItem<double>(
                                      value: speed,
                                      child: Text('${speed}x'),
                                    ),
                                ];
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  '${_videoPlayerController.value.playbackSpeed}x',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setOrientation();
                              },
                              icon: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
              :Container(
            color: Colors.black,
            height: MediaQuery.sizeOf(context).height * 0.3,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),


          )
        ],
      ),
    );
  }
}
