import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
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
       super.dispose();

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
                child: VideoPlayer(_videoPlayerController),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                       setState(() {
                         _videoPlayerController.value.isPlaying
                             ? _videoPlayerController.pause()
                             : _videoPlayerController.play();
                       });
                      }, icon: Icon( _videoPlayerController.value.isPlaying? Icons.pause:Icons.play_arrow,color: Colors.white,size: 30,)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz,color: Colors.white,size: 30,)),
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
