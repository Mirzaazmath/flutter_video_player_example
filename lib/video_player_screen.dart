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
  bool isFullScreen=false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =  VideoPlayerController.networkUrl(Uri.parse(
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'))
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


  void setOreintation(){
    if(isFullScreen){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

    }else{
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Column(
        children: [
          _videoPlayerController.value.isInitialized?
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(
                    _videoPlayerController,
                ),
              ),
              Column(
                children: [
                  VideoProgressIndicator(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      _videoPlayerController, allowScrubbing: true),
                  Row(

                    children: [
                      Expanded(
                        child:
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(onPressed: (){
                           setState(() {
                             _videoPlayerController.value.isPlaying
                                 ? _videoPlayerController.pause()
                                 : _videoPlayerController.play();
                           });
                          }, icon: Icon( _videoPlayerController.value.isPlaying? Icons.pause:Icons.play_arrow,color: Colors.white,size: 30,)),
                        ),
                      ),
                      PopupMenuButton<double>(
                        initialValue: _videoPlayerController.value.playbackSpeed,
                        tooltip: 'Playback speed',
                        onSelected: (double speed) {
                         setState(() {
                           _videoPlayerController.setPlaybackSpeed(speed);
                         });
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuItem<double>>[
                            for (final double speed in _examplePlaybackRates)
                              PopupMenuItem<double>(
                                value: speed,
                                child: Text('${speed}x'),
                              )
                          ];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(

                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Text('${_videoPlayerController.value.playbackSpeed}x',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),
                      IconButton(onPressed: (){
                        setState(() {
                          setOreintation();
                        });
                      }, icon: Icon(Icons.fullscreen,color: Colors.white,size: 30,))

                    ],
                  )
                ],
              )
            ],
          )
              : Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}

