import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sl/features/myPoints/controller/redeem_points_controller.dart';
import 'package:sl/model/offer_model.dart';
import 'package:sl/routes/app_routes.dart';

import '../../../shared/services/common_service.dart';
import '../../../shared/typography.dart';
import '../../../shared/utils/date_formators.dart';
import '../../../widgets/network_image_view.dart';

class RedeemPointsScreen extends StatefulWidget {
  const RedeemPointsScreen({super.key});

  @override
  State<RedeemPointsScreen> createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen> {
  OfferController offerController = Get.isRegistered<OfferController>()
      ? Get.find<OfferController>()
      : Get.put(OfferController());
  RxList<OfferModel> allCoupons = <OfferModel>[].obs;
  RxList<OfferModel> filteredCoupons = <OfferModel>[].obs;
  String searchQuery = '';
  RxBool isLoading = true.obs;
  late double availableBalance = 0;
  final List<String> bgImages = [
    "assets/images/offer1.png",
    "assets/images/offer2.png",
    "assets/images/offer3.png",
  ];

  @override
  void initState() {
    super.initState();
    _loadOffers();
    _fetchAvailableBalance();
  }

  void _fetchAvailableBalance({bool isRefresh = false}) async {
    CommonService.to.getUserDetails(forceRefresh: isRefresh).then((details) {
      setState(() {
        availableBalance = details.availablePoints;
      });
    });
  }

  Future<void> _loadOffers() async {
    try {
      isLoading.value = true;
      final coupons = await offerController.getAllOffers();

      if (coupons != null) {
        allCoupons.value = coupons;
        filteredCoupons.value = List.from(allCoupons);
      }
    } catch (error) {
      // Handle error, show a toast or dialog
      Get.snackbar(
        'Error',
        'Failed to load offers: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery = value.toLowerCase();
    if (searchQuery.isEmpty) {
      filteredCoupons.value = List.from(allCoupons);
      return;
    }
    filteredCoupons.value = allCoupons.where((coupon) {
      return coupon.title.toLowerCase().contains(searchQuery) ||
          coupon.description.toLowerCase().contains(searchQuery) ||
          coupon.termsAndConditions.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');

    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Redeem My Plus Points',
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : filteredCoupons.isEmpty
            ? Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/emptyIcon.png', height: 120),
                      Text(
                        'No offers available',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  // Balance Points Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset("assets/images/amountBg.png").image,
                        fit: BoxFit.contain,
                      ),
                      // gradient: const LinearGradient(
                      //   colors: [Color(0xFFB745FC), Color(0xFF8E1DC3)],
                      // ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // const Icon(
                        //   Icons.card_giftcard,
                        //   color: Colors.white,
                        //   size: 36,
                        // ),
                        const SizedBox(width: 100),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Balance Plus Points',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              currencyFormat.format(availableBalance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔽 White container for search + coupon list
                  Expanded(
                    child: Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Search Box
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              onChanged: updateSearch,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: AppTypography.bodySmall(color: Colors.grey.shade500),
                                suffixIcon:Image.asset(
                                  'assets/images/searchIcon.png',
                                  height: 20,
                                  width: 20,
                                  color: Colors.grey.shade500,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Coupon List
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredCoupons.length,
                              itemBuilder: (context, index) {
                                final coupon = filteredCoupons[index];
                                return CouponCard(coupon: coupon);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}

class CouponCard extends StatefulWidget {
  final OfferModel coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  final List<String> bgImages = [
    "assets/images/offer1.png",
    "assets/images/offer2.png",
    "assets/images/offer3.png",
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final bgImage = bgImages[random.nextInt(bgImages.length)];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                'Plus Point: ${widget.coupon.points}',
                style: AppTypography.heading6(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 18),

          // Main content with title, image, valid till, and button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Image Row
                Text(
                  widget.coupon.title,

                  style: AppTypography.heading5(color: Colors.white),
                ),

                const SizedBox(height: 5),

                Divider(thickness: 0.4),
                const SizedBox(height: 5),

                // Valid Till + View Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valid till:',
                            style: AppTypography.labelSmall(color: Colors.white70),
                          ),
                          Text(
                            DateFormators.formatDate(widget.coupon.validTill),
                            style: AppTypography.labelMedium(color: Colors.white),
                          
                        
                          ),
                          // if (widget.coupon.qrCodeStats != null) ...[
                          //   const SizedBox(height: 4),
                          //   Text(
                          //     'Available: ${widget.coupon.qrCodeStats!.available}/${widget.coupon.qrCodeStats!.total}',
                          //     style: const TextStyle(
                          //       color: Colors.white70,
                          //       fontSize: 11,
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.coupon.isRedeemable
                          ? () {
                              context.push(
                                AppRoutes.productDetail,
                                extra: widget.coupon.id,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: widget.coupon.isRedeemable
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                      child: Text(
                        widget.coupon.isRedeemable
                            ? 'View Details'
                            : 'Not Available',
                        style: AppTypography.labelMedium(
                          color: widget.coupon.isRedeemable
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
