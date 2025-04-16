import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // Here we have created a _videoPlayerController to controller our video
  late VideoPlayerController _videoPlayerController;
  // Here We have created PlaybackRates list to controller the speed of the video
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
  // Here we have created a variable of type bool to handle  FullScreen mode
  bool isFullScreen = false;
  // Here we have created a variable of type bool to handle  Forward effect
  bool _showDoubleTapIconForward = false;
  // Here we have created a variable of type bool to handle  Backward effect
  bool _showDoubleTapIconBackward = false;

  @override
  void initState() {
    super.initState();
    // Here we are Initializing the VideoPlayerController of networkUrl with video url
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
    // Here we are disposing the _videoPlayerController to prevent memory leak
    _videoPlayerController.dispose();
    // here we are setting the screen orientation to portrait while closing the videoPlayer screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Here we have created a method to change the Orientation of video player screen
  void setOrientation() {
    // if the video player is in FullScreen we simple setting the Orientation to portrait mode
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      // if not  we simple setting the Orientation to landscape mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    // Here we are changing the  isFullScreen value
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // based on FullScreen mode we are hiding the appbar to better user experience
      appBar: isFullScreen ? null : AppBar(title: Text("Video Player")),
      body: Column(
        children: [
          // Here we are checking weather the _videoPlayerController Initialized or not, if not then we are showing the loader
          _videoPlayerController.value.isInitialized
              // here we are wrapping the videoPlayer with Stack to arrange controller over the videoPlayer
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    // here we are changing the height based on FullScreen mode
                    height:
                        isFullScreen
                            ? MediaQuery.sizeOf(context).height
                            : MediaQuery.sizeOf(context).height * 0.3,
                    width: double.infinity,
                    // Here is the VideoPlayer which will display to user
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  // here we have create two transparent controller to skip and rewind the video duration by 10 seconds
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
                  // here we are showing back arrow in fullscreen mode to pop
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
                        // VideoProgressIndicator
                        SizedBox(
                          height: 10,
                          child: VideoProgressIndicator(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            _videoPlayerController,
                            allowScrubbing: true,
                          ),
                        ),
                        Row(
                          children: [
                            // pause and play button
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
                            // Video Speed mode dropdown
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
                            // FullScreen mode button
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
              // Loader
              : Container(
                color: Colors.black,
                height: MediaQuery.sizeOf(context).height * 0.3,
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: Colors.white),
              ),
        ],
      ),
    );
  }
}
