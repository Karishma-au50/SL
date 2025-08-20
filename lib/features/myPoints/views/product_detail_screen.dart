import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sl/features/myPoints/controller/redeem_points_controller.dart';
import 'package:sl/shared/app_colors.dart';

import '../../../model/offer_model.dart';
import '../../../shared/constant/font_helper.dart' show FontHelper;
import '../../../shared/typography.dart';
import '../../../shared/utils/date_formators.dart';
import '../../../widgets/network_image_view.dart';
import '../../../widgets/toast/my_toast.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  OfferController offerController = Get.isRegistered<OfferController>()
      ? Get.find<OfferController>()
      : Get.put(OfferController());
  Rx<OfferModel?> offerDetail = Rx<OfferModel?>(null);
  final RxBool isLoad = true.obs;

  @override
  void initState() {
    super.initState();
    _loadOfferDetails();
  }

  Future<void> _loadOfferDetails() async {
    try {
      await offerController.getOfferById(widget.productId).then((value) {
        if (value != null) {
          offerDetail(value);
        }
        isLoad.value = false;
      });
    } catch (e) {
      MyToasts.toastError("Failed to load details $e");
      isLoad.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        leading: const BackButton(color: Colors.white),
        title: Text(
          'Redeem My Plus Points',
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return isLoad.value
            ? const Center(child: CircularProgressIndicator())
            : offerDetail.value == null
            ? Center(
                child: Text(
                  'No offer details available',
                  style: FontHelper.ts14w400(color: Colors.red),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: CarouselView(
                          itemExtent: 400,
                          children: [
                            if (offerDetail.value?.productId.images.isEmpty ??
                                true)
                              Image.asset(
                                'assets/images/defaultProductLogo.png',
                                height: 60,
                              ),
                            for (var imgUrl
                                in (offerDetail.value?.productId.images ?? []))
                              NetworkImageView(imgUrl: imgUrl, radius: 12),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        offerDetail.value?.title ?? '',
                        textAlign: TextAlign.center,
                        style: AppTypography.heading6(color: Color(0xFF001518)),
                      ),

                      const SizedBox(height: 10),

                      // Points button
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF03939C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Plus Point ${offerDetail.value?.points ?? 0}',
                            style: AppTypography.heading6(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Validity date
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/calender.png',
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 8),

                            Text(
                              'Valid till: ',
                              style: AppTypography.bodySmall(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormators.formatDate(
                                offerDetail.value!.validTill,
                              ),
                              style: AppTypography.labelLarge(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              offerDetail.value?.productRating.toString() ??
                                  '0',
                              style: AppTypography.heading4(
                                color: Color(0xFFFF9222),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Rating',
                                    style: AppTypography.labelMedium(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const Icon(
                                    Icons.star_half,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${offerDetail.value?.productRatingCount.toString() ?? '0'} Rating and Reviews',
                                style: AppTypography.labelLarge(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 32),

                      // Specification
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Specification:',
                          style: AppTypography.labelLarge(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        offerDetail.value?.specifications ?? "",
                        style: AppTypography.labelMedium(
                          color: AppColors.kcDefaultText,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // About
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'About this item:',
                          style: AppTypography.labelLarge(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        offerDetail.value?.description ?? '',
                        style: AppTypography.labelMedium(
                          color: AppColors.kcDefaultText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Terms & Conditions:',
                          style: AppTypography.labelLarge(color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        offerDetail.value?.termsAndConditions ?? '',
                        style: AppTypography.labelMedium(
                          color: AppColors.kcDefaultText,
                        ),
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
