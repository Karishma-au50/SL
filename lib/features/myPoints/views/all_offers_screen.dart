import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../model/offer_model.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/utils/date_formators.dart' show DateFormators;
import '../controller/redeem_points_controller.dart';

class AllOffersScreen extends StatefulWidget {
  AllOffersScreen({super.key});

  @override
  State<AllOffersScreen> createState() => _AllOffersScreenState();
}

class _AllOffersScreenState extends State<AllOffersScreen> {
  final List<String> bgImages = [
    "assets/images/offerImg1.png",
    "assets/images/offerImg2.png",
    "assets/images/offerImg3.png",
  ];

  final List<Map<String, String>> offers = [
    {
      "title": "SL Paints and Chemicals Dhamaka Offer, 2025",
      "date": "26 August, 2025",
      "image": "assets/images/defaultProductLogo.png"
    },
    {
      "title": "SL Paints and Chemicals Dhamaka Offer, 2025",
      "date": "26 August, 2025",
      "image": "assets/images/defaultProductLogo.png"
    },
    {
      "title": "SL Paints and Chemicals Dhamaka Offer, 2025",
      "date": "26 August, 2025",
      "image": "assets/images/defaultProductLogo.png"
    },
    {
      "title": "SL Paints and Chemicals Dhamaka Offer, 2025",
      "date": "26 August, 2025",
      "image": "assets/images/defaultProductLogo.png"
    },
    {
      "title": "SL Paints and Chemicals Dhamaka Offer, 2025",
      "date": "26 August, 2025",
      "image": "assets/images/defaultProductLogo.png"
    },
  ];
    OfferController offerController = Get.isRegistered<OfferController>()
      ? Get.find<OfferController>()
      : Get.put(OfferController());
    RxBool isLoading = true.obs;
    RxList<OfferModel> allCoupons = <OfferModel>[].obs;

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


  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B23),
        title: const Text(
          "Offers",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: Obx(
      () {
           return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : allCoupons.isEmpty
            ?  Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/emptyIcon.png',
                      height: 120,
                    ),
                    Text(
                      'No offers available',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: allCoupons.length,
                    itemBuilder: (context, index) {
                      final offer = allCoupons[index];
                      final bgImage = bgImages[random.nextInt(bgImages.length)];
                      return GestureDetector(
                        onTap: () {
                          // Handle offer tap
                            context.push(
                                AppRoutes.productDetail,
                                extra: offer.id,
                              );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(bgImage),
                              fit: BoxFit.cover,
                            ),
                            // borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/defaultProductLogo.png', height: 60),
                              const SizedBox(width: 50),
                              // Spacer(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer.title,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Valid date\n${DateFormators.formatDate(offer.validTill)}",
                                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "View Details →",
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
