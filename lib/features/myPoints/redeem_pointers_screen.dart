import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/features/myPoints/controller/redeem_points_controller.dart';
import 'package:sl/model/offer_model.dart';
import 'package:sl/routes/app_routes.dart';

import '../../shared/utils/date_formators.dart';
import '../../widgets/network_image_view.dart';

class RedeemPointsScreen extends StatefulWidget {
  const RedeemPointsScreen({super.key});

  @override
  State<RedeemPointsScreen> createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen> {
  OfferController offerController = Get.isRegistered<OfferController>()
      ? Get.find<OfferController>()
      : Get.put(OfferController());
  int balancePoints = 100;
  RxList<OfferModel> allCoupons = <OfferModel>[].obs;
  RxList<OfferModel> filteredCoupons = <OfferModel>[].obs;
  String searchQuery = '';
  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _loadOffers();
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
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Redeem My Plus Points',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : filteredCoupons.isEmpty
            ? const Center(
                child: Text(
                  'No offers available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : Column(
                children: [
                  // Balance Points Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB745FC), Color(0xFF8E1DC3)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Balance Plus Points',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              '$balancePoints',
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
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              onChanged: updateSearch,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade300,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
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

class CouponCard extends StatelessWidget {
  final OfferModel coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color:  Colors.blueGrey.withValues(alpha: 0.9),
       gradient: const LinearGradient(
                        colors: [Color(0xFFB745FC), Color(0xFF8E1DC3)],
                      ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                'Plus Point: ${coupon.points}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                  coupon.title,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
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
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormators.formatDate(coupon.validTill),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (coupon.qrCodeStats != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Available: ${coupon.qrCodeStats!.available}/${coupon.qrCodeStats!.total}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: coupon.isRedeemable
                          ? () {
                              context.push(
                                AppRoutes.productDetail,
                                extra: coupon.id,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: coupon.isRedeemable
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                      child: Text(
                        coupon.isRedeemable ? 'View Details' : 'Not Available',
                        style: TextStyle(
                          color: coupon.isRedeemable
                              ? Colors.white
                              : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
