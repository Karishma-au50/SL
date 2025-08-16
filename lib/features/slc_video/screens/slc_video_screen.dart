import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../features/home/controller/dashboard_controller.dart';
import '../../../model/slc_video_model.dart';
import '../../../shared/app_colors.dart';
import '../../../widgets/toast/my_toast.dart';

class SLCVideoScreen extends StatefulWidget {
  const SLCVideoScreen({super.key});

  @override
  State<SLCVideoScreen> createState() => _SLCVideoScreenState();
}

class _SLCVideoScreenState extends State<SLCVideoScreen> {
  final DashboardController _controller = Get.find<DashboardController>();
  SLCVideoModel? videoData;
  bool isLoading = true;
  int selectedTabIndex = 0;
  
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
      if (data != null) {
        setState(() {
          videoData = data;
          isLoading = false;
        });
        _initializeControllers();
      } else {
        setState(() {
          isLoading = false;
        });
        MyToasts.toastError("Failed to load videos");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      MyToasts.toastError("Error loading videos: ${e.toString()}");
    }
  }

  void _initializeControllers() {
    if (videoData == null) return;

    // Initialize video player controllers for network videos
    for (String videoUrl in videoData!.video) {
      if (_isValidUrl(videoUrl)) {
        final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        videoControllers[videoUrl] = controller;
        controller.initialize();
      }
    }

    // Initialize YouTube controllers
    for (String youtubeUrl in videoData!.url) {
      final videoId = YoutubePlayerController.convertUrlToId(youtubeUrl);
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
        youtubeControllers[youtubeUrl] = controller;
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
            aspectRatio: controller.value.aspectRatio,
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
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
    if (videoData == null) return const SizedBox();

    if (selectedTabIndex == 0) {
      // Network videos tab
      if (videoData!.video.isEmpty) {
        return const Center(
          child: Text(
            "No network videos available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videoData!.video.length,
        itemBuilder: (context, index) {
          final videoUrl = videoData!.video[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Video ${index + 1}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildVideoPlayer(videoUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    videoUrl,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // YouTube videos tab
      if (videoData!.url.isEmpty) {
        return const Center(
          child: Text(
            "No YouTube videos available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videoData!.url.length,
        itemBuilder: (context, index) {
          final youtubeUrl = videoData!.url[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YouTube Video ${index + 1}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildYouTubePlayer(youtubeUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    youtubeUrl,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SLC Videos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.kcPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadSLCVideos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.kcPrimaryColor,
              ),
            )
          : videoData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Failed to load videos",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSLCVideos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kcPrimaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Tab bar
                    Container(
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTabIndex = 0;
                                });
                                _pauseAllVideos();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: selectedTabIndex == 0
                                      ? AppColors.kcPrimaryColor
                                      : Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: selectedTabIndex == 0
                                          ? AppColors.kcPrimaryColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Network Videos (${videoData!.video.length})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedTabIndex == 0
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTabIndex = 1;
                                });
                                _pauseAllVideos();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: selectedTabIndex == 1
                                      ? AppColors.kcPrimaryColor
                                      : Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: selectedTabIndex == 1
                                          ? AppColors.kcPrimaryColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "YouTube Videos (${videoData!.url.length})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedTabIndex == 1
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Video list
                    Expanded(
                      child: _buildVideoList(),
                    ),
                  ],
                ),
    );
  }
}
