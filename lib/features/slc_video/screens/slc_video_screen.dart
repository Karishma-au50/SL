import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../features/home/controller/dashboard_controller.dart';
import '../../../model/slc_video_model.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/constant/app_constants.dart';
import '../../../shared/typography.dart';
import '../../../widgets/toast/my_toast.dart';

class SLCVideoScreen extends StatefulWidget {
  const SLCVideoScreen({super.key});

  @override
  State<SLCVideoScreen> createState() => _SLCVideoScreenState();
}

class _SLCVideoScreenState extends State<SLCVideoScreen> {
  final DashboardController _controller = Get.find<DashboardController>();
  List<SLCVideoModel> videoList = [];
  bool isLoading = true;
  // Video player controllers
  Map<String, VideoPlayerController> videoControllers = {};
  Map<String, YoutubePlayerController> youtubeControllers = {};
  String? currentPlayingVideo;
  String? currentPlayingYoutube;

  @override
  void initState() {
    super.initState();
    _loadSLCVideos();
  }

  Future<void> _loadSLCVideos() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await _controller.getSLCVideos();
      setState(() {
        videoList = data;
        isLoading = false;
      });
      _initializeControllers();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      MyToasts.toastError("Error loading videos: ${e.toString()}");
    }
  }

  void _initializeControllers() {
    for (var video in videoList) {
      final url = video.videoUrl;
      final isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
      if (isYouTube) {
        final videoId = YoutubePlayerController.convertUrlToId(url);
        if (videoId != null) {
          final controller = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(
              mute: false,
              showControls: true,
              showFullscreenButton: false,  
              loop: false,
            ),
          );
          youtubeControllers[url] = controller;
        }
      } else if (_isValidUrl(AppConstants.videoUrl+url)) {
        final controller = VideoPlayerController.networkUrl(Uri.parse(AppConstants.videoUrl+url));
        videoControllers[url] = controller;
        controller.initialize();
      }
    }
  }

  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _pauseAllVideos() {
    // Pause all network videos
    for (var controller in videoControllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }

    // Pause all YouTube videos
    for (var controller in youtubeControllers.values) {
      controller.pauseVideo();
    }

    currentPlayingVideo = null;
    currentPlayingYoutube = null;
  }

  Widget _buildVideoPlayer(String videoUrl) {
    final controller = videoControllers[videoUrl];
    if (controller == null) return const SizedBox();

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                VideoPlayer(controller),
                Center(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (controller.value.isPlaying) {
                          controller.pause();
                          currentPlayingVideo = null;
                        } else {
                          _pauseAllVideos();
                          controller.play();
                          currentPlayingVideo = videoUrl;
                        }
                      });
                    },
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: AppColors.kcPrimaryColor,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildYouTubePlayer(String youtubeUrl) {
    final controller = youtubeControllers[youtubeUrl];
    if (controller == null) return const SizedBox();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: controller,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildVideoList() {
    if (videoList.isEmpty) {
      return const Center(
        child: Text(
          "No videos available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      // padding: const EdgeInsets.all(16),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        final video = videoList[index];
        final url = video.videoUrl;
        final isYouTube =
            url.contains('youtube.com') || url.contains('youtu.be');
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isYouTube
                    ? _buildYouTubePlayer(url)
                    : _buildVideoPlayer(url),
              ),
              const SizedBox(height: 10),
              Text(
                video.description,
                style: AppTypography.labelLarge(
                  color: Color(0xFF1D1F22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose video controllers
    for (var controller in videoControllers.values) {
      controller.dispose();
    }

    // Dispose YouTube controllers
    for (var controller in youtubeControllers.values) {
      controller.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B23),
        title: Text(
          "SLC Videos",
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildVideoList(),
      ),
    );
  }
}
