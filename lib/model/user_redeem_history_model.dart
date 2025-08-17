class UserRedeemHistoryModel {
  final PointsSummary pointsSummary;
  final List<RecentRedemption> recentRedemptions;

  UserRedeemHistoryModel({
    required this.pointsSummary,
    required this.recentRedemptions,
  });

  factory UserRedeemHistoryModel.fromJson(Map<String, dynamic> json) {
    // first check points summary has rows or not

    UserRedeemHistoryModel model;

    final recentRedemptions = (json['recentRedemptions'] as List<dynamic>)
        .map((e) => RecentRedemption.fromJson(e as Map<String, dynamic>))
        .toList();

    if (json['pointsSummary'] != null && json['pointsSummary'].isNotEmpty) {
      model = UserRedeemHistoryModel(
        pointsSummary: PointsSummary.fromJson(
          json['pointsSummary'][0] as Map<String, dynamic>,
        ),
        recentRedemptions: recentRedemptions,
      );
    } else {
      model = UserRedeemHistoryModel(
        pointsSummary: PointsSummary(id: '', count: 0, totalPoints: 0),
        recentRedemptions: recentRedemptions,
      );
    }

    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'pointsSummary': [pointsSummary.toJson()],
      'recentRedemptions': recentRedemptions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'UserRedeemHistoryModel(pointsSummary: $pointsSummary, recentRedemptions: $recentRedemptions)';
  }
}

class PointsSummary {
  final String id;
  final int count;
  final int totalPoints;

  PointsSummary({
    required this.id,
    required this.count,
    required this.totalPoints,
  });

  factory PointsSummary.fromJson(Map<String, dynamic> json) {
    return PointsSummary(
      id: json['_id'] ?? '',
      count: json['count'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'count': count, 'totalPoints': totalPoints};
  }

  @override
  String toString() {
    return 'PointsSummary(id: $id, count: $count, totalPoints: $totalPoints)';
  }
}

class RecentRedemption {
  final RedemptionMetadata metadata;
  final String id;
  final String userId;
  final OfferInfo offerId;
  final String qrCodeId;
  final String redemptionCode;
  final int pointsEarned;
  final String redemptionStatus;
  final String redemptionMethod;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  RecentRedemption({
    required this.metadata,
    required this.id,
    required this.userId,
    required this.offerId,
    required this.qrCodeId,
    required this.redemptionCode,
    required this.pointsEarned,
    required this.redemptionStatus,
    required this.redemptionMethod,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory RecentRedemption.fromJson(Map<String, dynamic> json) {
    return RecentRedemption(
      metadata: RedemptionMetadata.fromJson(json['metadata'] ?? {}),
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      offerId: OfferInfo.fromJson(json['offerId'] ?? {}),
      qrCodeId: json['qrCodeId'] ?? '',
      redemptionCode: json['redemptionCode'] ?? '',
      pointsEarned: json['pointsEarned'] ?? 0,
      redemptionStatus: json['redemptionStatus'] ?? '',
      redemptionMethod: json['redemptionMethod'] ?? '',
      completedAt: DateTime.parse(
        json['completedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      '_id': id,
      'userId': userId,
      'offerId': offerId.toJson(),
      'qrCodeId': qrCodeId,
      'redemptionCode': redemptionCode,
      'pointsEarned': pointsEarned,
      'redemptionStatus': redemptionStatus,
      'redemptionMethod': redemptionMethod,
      'completedAt': completedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  @override
  String toString() {
    return 'RecentRedemption(id: $id, redemptionCode: $redemptionCode, pointsEarned: $pointsEarned, redemptionStatus: $redemptionStatus)';
  }
}

class RedemptionMetadata {
  final DateTime scanTimestamp;
  final int processingTime;

  RedemptionMetadata({
    required this.scanTimestamp,
    required this.processingTime,
  });

  factory RedemptionMetadata.fromJson(Map<String, dynamic> json) {
    return RedemptionMetadata(
      scanTimestamp: DateTime.parse(
        json['scanTimestamp'] ?? DateTime.now().toIso8601String(),
      ),
      processingTime: json['processingTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scanTimestamp': scanTimestamp.toIso8601String(),
      'processingTime': processingTime,
    };
  }

  @override
  String toString() {
    return 'RedemptionMetadata(scanTimestamp: $scanTimestamp, processingTime: $processingTime)';
  }
}

class OfferInfo {
  final String id;
  final int points;
  final ProductInfo? productId;

  OfferInfo({
    required this.id,
    required this.points,
    this.productId,
  });

  factory OfferInfo.fromJson(Map<String, dynamic> json) {
    return OfferInfo(
      id: json['_id'] ?? '',
      points: json['points'] ?? 0,
      productId: json['productId'] != null
          ? ProductInfo.fromJson(json['productId'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'points': points,
      'productId': productId?.toJson(),
    };
  }

  @override
  String toString() {
    return 'OfferInfo(id: $id, points: $points, productId: $productId)';
  }
}

class ProductInfo {
  final String id;
  final String title;
  final List<String> images;
  final String specifications;
  final String termsAndConditions;
  final String description;
  final double price;
  final double productRating;
  final int productRatingCount;
  final bool isActive;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  ProductInfo({
    required this.id,
    required this.title,
    required this.images,
    required this.specifications,
    required this.termsAndConditions,
    required this.description,
    required this.price,
    required this.productRating,
    required this.productRatingCount,
    required this.isActive,
    required this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      specifications: json['specifications'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      productRating: (json['productRating'] ?? 0).toDouble(),
      productRatingCount: json['productRatingCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      deletedBy: json['deletedBy'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'images': images,
      'specifications': specifications,
      'termsAndConditions': termsAndConditions,
      'description': description,
      'price': price,
      'productRating': productRating,
      'productRatingCount': productRatingCount,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  @override
  String toString() {
    return 'ProductInfo(id: $id, title: $title, price: $price, isActive: $isActive)';
  }
}
