class OfferModel {
  final String id;
  final int points;
  final String termsAndConditions;
  final bool isRedeemable;
  final DateTime validTill;
  final int totalQRCodes;
  final int redeemedCount;
  final bool isActive;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductModel productId;
  final QRCodeStats? qrCodeStats;

  OfferModel({
    required this.id,
    required this.points,
    required this.termsAndConditions,
    required this.isRedeemable,
    required this.validTill,
    required this.totalQRCodes,
    required this.redeemedCount,
    required this.isActive,
    required this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    this.qrCodeStats,
  });

  // Getters for backward compatibility
  String get title => productId.title;
  List<String> get images => productId.images;
  String get specifications => productId.specifications;
  String get description => productId.description;
  double get price => productId.price;
  double get productRating => 0.0; // Default value since not in new API
  int get productRatingCount => 0; // Default value since not in new API

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['_id'] ?? '',
      points: json['points'] ?? 0,
      termsAndConditions: json['termsAndConditions'] ?? '',
      isRedeemable: json['isRedeemable'] ?? false,
      validTill: DateTime.parse(json['validTill'] ?? DateTime.now().toIso8601String()),
      totalQRCodes: json['totalQRCodes'] ?? 0,
      redeemedCount: json['redeemedCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      deletedBy: json['deletedBy'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      productId: ProductModel.fromJson(json['productId'] ?? {}),
      qrCodeStats: json['qrCodeStats'] != null 
          ? QRCodeStats.fromJson(json['qrCodeStats']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'points': points,
      'termsAndConditions': termsAndConditions,
      'isRedeemable': isRedeemable,
      'validTill': validTill.toIso8601String(),
      'totalQRCodes': totalQRCodes,
      'redeemedCount': redeemedCount,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'productId': productId.toJson(),
      'qrCodeStats': qrCodeStats?.toJson(),
    };
  }

  String get formattedValidTill {
    return "${validTill.day} ${_getMonthName(validTill.month)}, ${validTill.year}";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class ProductModel {
  final String id;
  final String title;
  final List<String> images;
  final String specifications;
  final String description;
  final double price;

  ProductModel({
    required this.id,
    required this.title,
    required this.images,
    required this.specifications,
    required this.description,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      specifications: json['specifications'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'images': images,
      'specifications': specifications,
      'description': description,
      'price': price,
    };
  }
}

class QRCodeStats {
  final String? id;
  final int total;
  final int used;
  final int available;

  QRCodeStats({
    this.id,
    required this.total,
    required this.used,
    required this.available,
  });

  factory QRCodeStats.fromJson(Map<String, dynamic> json) {
    return QRCodeStats(
      id: json['_id'],
      total: json['total'] ?? 0,
      used: json['used'] ?? 0,
      available: json['available'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'total': total,
      'used': used,
      'available': available,
    };
  }
}

class OfferResponse {
  final List<OfferModel> offers;
  final PaginationModel pagination;

  OfferResponse({
    required this.offers,
    required this.pagination,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalOffers;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalOffers,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  // Getters for backward compatibility
  bool get hasNext => hasNextPage;
  bool get hasPrev => hasPrevPage;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalOffers: json['totalOffers'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalOffers': totalOffers,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
