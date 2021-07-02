import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_search/video_provider.dart';

class VideoPage extends StatefulWidget {
  final String videoURL;
  VideoPage(this.videoURL);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var videoProvider = Provider.of<VideoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(videoProvider.selectedvideoTittle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Expanded(
                child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Label searched timestamps',
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Expanded(
                    child: ListView.builder(
                  itemCount: videoProvider.selectedlabelTimestamps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(videoProvider.selectedlabelTimestamps[index]),
                      onTap: () {
                        setState(() {
                          //TODO: Redireccionar al timestamp seleccionado
                          _controller.seekTo(const Duration(seconds: 10));
                        });
                      },
                    );
                  },
                ))
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
