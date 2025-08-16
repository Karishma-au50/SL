class SLCVideoModel {
  final List<String> video;
  final List<String> url;

  SLCVideoModel({
    required this.video,
    required this.url,
  });

  factory SLCVideoModel.fromJson(Map<String, dynamic> json) {
    return SLCVideoModel(
      video: (json['video'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      url: (json['url'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video,
      'url': url,
    };
  }

  List<VideoItem> get allVideoItems {
    List<VideoItem> items = [];
    
    // Add network videos
    for (int i = 0; i < video.length; i++) {
      items.add(VideoItem(
        title: "SLC Video ${i + 1}",
        videoUrl: video[i],
        type: VideoType.networkVideo,
        thumbnailUrl: null, // You can add thumbnail URLs from API if available
      ));
    }
    
    // Add YouTube URLs
    for (int i = 0; i < url.length; i++) {
      items.add(VideoItem(
        title: "SLC YouTube Video ${i + 1}",
        videoUrl: url[i],
        type: VideoType.youtubeUrl,
        thumbnailUrl: _getYouTubeThumbnail(url[i]),
      ));
    }
    
    return items;
  }

  String? _getYouTubeThumbnail(String youtubeUrl) {
    // Extract video ID from YouTube URL and generate thumbnail
    final regex = RegExp(r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\n?#]+)');
    final match = regex.firstMatch(youtubeUrl);
    if (match != null) {
      final videoId = match.group(1);
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return null;
  }

  @override
  String toString() {
    return 'SLCVideoModel(video: $video, url: $url)';
  }
}

enum VideoType { networkVideo, youtubeUrl }

class VideoItem {
  final String title;
  final String videoUrl;
  final VideoType type;
  final String? thumbnailUrl;

  VideoItem({
    required this.title,
    required this.videoUrl,
    required this.type,
    this.thumbnailUrl,
  });

  @override
  String toString() {
    return 'VideoItem(title: $title, videoUrl: $videoUrl, type: $type)';
  }
}
