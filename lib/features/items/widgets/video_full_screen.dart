import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../config/helpers.dart';

class FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final void Function()? onClose;

  const FullscreenVideoPlayer({super.key, required this.controller, this.onClose});

  @override
  _FullscreenVideoPlayerState createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.controller.play();
    _isVideoPlaying = widget.controller.value.isPlaying;

    widget.controller.addListener(() {
      setState(() {}); // Update UI based on video progress
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isVideoPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isVideoPlaying = !_isVideoPlaying;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: (){
                _togglePlayPause();
              },
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: widget.onClose,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    widget.controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white30,
                    ),
                  ),
                ),
                Box(w: 10),
                Text(
                  _formatDuration(widget.controller.value.position),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration position) {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
