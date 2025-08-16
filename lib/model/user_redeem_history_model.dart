class UserRedeemHistoryModel {
  final PointsSummary pointsSummary;
  final List<RecentRedemption> recentRedemptions;

  UserRedeemHistoryModel({
    required this.pointsSummary,
    required this.recentRedemptions,
  });

  factory UserRedeemHistoryModel.fromJson(Map<String, dynamic> json) {
    return UserRedeemHistoryModel(
      pointsSummary: PointsSummary.fromJson(json['pointsSummary']?[0] ?? {}),
      recentRedemptions: (json['recentRedemptions'] as List<dynamic>?)
              ?.map((e) => RecentRedemption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
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
    return {
      '_id': id,
      'count': count,
      'totalPoints': totalPoints,
    };
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

  OfferInfo({
    required this.id,
    required this.points,
  });

  factory OfferInfo.fromJson(Map<String, dynamic> json) {
    return OfferInfo(
      id: json['_id'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'points': points,
    };
  }

  @override
  String toString() {
    return 'OfferInfo(id: $id, points: $points)';
  }
}
