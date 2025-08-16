class SLCVideoModel {
  final String url;
  final String description;

  SLCVideoModel({required this.url, required this.description});

  factory SLCVideoModel.fromJson(Map<String, dynamic> json) {
    return SLCVideoModel(
      url: json['url'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'description': description};
  }

  List<VideoItem> get allVideoItems {
    // Determine type based on URL
    final isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
    return [
      VideoItem(
        title: description,
        videoUrl: url,
        type: isYouTube ? VideoType.youtubeUrl : VideoType.networkVideo,
        thumbnailUrl: isYouTube ? _getYouTubeThumbnail(url) : null,
      ),
    ];
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
    return 'SLCVideoModel(url: $url, description: $description)';
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
