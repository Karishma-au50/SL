class HomeBannerModel {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeBannerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isdeleted'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'isdeleted': isDeleted,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get full image URL
  String getImageUrl({String baseUrl = ''}) {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return baseUrl.isEmpty ? image : '$baseUrl/$image';
  }

  // Helper method to get formatted creation date
  String getFormattedCreatedAt() {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  // Helper method to get formatted update date
  String getFormattedUpdatedAt() {
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
  }

  @override
  String toString() {
    return 'HomeBannerModel(id: $id, name: $name, image: $image, isDeleted: $isDeleted, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeBannerModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  // Copy with method for updating instances
  HomeBannerModel copyWith({
    String? id,
    String? name,
    String? image,
    bool? isDeleted,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HomeBannerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isDeleted: isDeleted ?? this.isDeleted,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

        // make model 
