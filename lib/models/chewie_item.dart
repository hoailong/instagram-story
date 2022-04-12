import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const ChewieItem({required this.videoPlayerController, Key? key})
      : super(key: key);
  @override
  _ChewieItemState createState() => _ChewieItemState();
}

class _ChewieItemState extends State<ChewieItem> {
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        allowMuting: false,
        aspectRatio: 0.55,
        // autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
              child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Chewie(controller: _chewieController),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (widget.videoPlayerController.value.isPlaying)
      widget.videoPlayerController.pause();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
