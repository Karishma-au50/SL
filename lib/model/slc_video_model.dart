class SLCVideoResponse {
  final List<SLCVideoModel> data;

  SLCVideoResponse({required this.data});

  factory SLCVideoResponse.fromJson(Map<String, dynamic> json) {
    return SLCVideoResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => SLCVideoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((video) => video.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SLCVideoResponse(data: $data)';
  }
}

class SLCVideoModel {
  final String id;
  final String type;
  final String videoUrl;
  final String description;
  final String createdAt;
  final String updatedAt;

  SLCVideoModel({
    required this.id,
    required this.type,
    required this.videoUrl,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SLCVideoModel.fromJson(Map<String, dynamic> json) {
    return SLCVideoModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      videoUrl: json['VideoUrl'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'VideoUrl': videoUrl,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  List<VideoItem> get allVideoItems {
    // Determine type based on VideoUrl and type field
    final isYouTube = type.toLowerCase() == 'youtube' || 
                      videoUrl.contains('youtube.com') || 
                      videoUrl.contains('youtu.be');
    return [
      VideoItem(
        title: description,
        videoUrl: videoUrl,
        type: isYouTube ? VideoType.youtubeUrl : VideoType.networkVideo,
        thumbnailUrl: isYouTube ? _getYouTubeThumbnail(videoUrl) : null,
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
    return 'SLCVideoModel(id: $id, type: $type, videoUrl: $videoUrl, description: $description)';
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
