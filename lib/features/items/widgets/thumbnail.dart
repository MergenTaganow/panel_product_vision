import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../config/colors.dart';

class VideoWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullscreen;
  final VoidCallback onTap;

  const VideoWidget({
    super.key,
    required this.controller,
    required this.onFullscreen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the toggle play/pause function from the main widget
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.isInitialized ? controller.value.aspectRatio : 16 / 9,
            child: VideoPlayer(controller),
          ),
          if (!controller.value.isPlaying) // Show play icon when paused
            const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 60,
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Col.primary,
              ),
              onPressed: onFullscreen, // Trigger fullscreen mode
            ),
          ),
        ],
      ),
    );
  }
}
