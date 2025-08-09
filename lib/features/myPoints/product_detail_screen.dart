import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sl/features/myPoints/controller/redeem_points_controller.dart';

import '../../model/offer_model.dart';
import '../../shared/constant/font_helper.dart' show FontHelper;
import '../../shared/utils/date_formators.dart';
import '../../widgets/network_image_view.dart';
import '../../widgets/toast/my_toast.dart';

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
                  padding: const EdgeInsets.all(14.0),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: CarouselView(
                          itemExtent: 400,
                          children: [
                            for (var imgUrl
                                in (offerDetail.value?.productId.images ?? []))
                              NetworkImageView(imgUrl: imgUrl, radius: 12),
                          ],
                        ),
                      ),

                      // Product Image
                      // Center(
                      //   child: Image.network(
                      //    "https://i.pinimg.com/1200x/3b/48/36/3b4836cfe35bb48df602697edca97521.jpg",
                      //     height: 200,
                      //   ),
                      // ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        offerDetail.value?.title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Points button
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Plus Point ${offerDetail.value?.points ?? 0}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Validity date
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),

                            Text(
                              'Valid till:${DateFormators.formatDate(offerDetail.value!.validTill)}',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              offerDetail.value?.productRating.toString() ??
                                  '0',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                                  const Text(
                                    'Product Rating',
                                    style: TextStyle(color: Colors.black54),
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
                              Text(
                                '${offerDetail.value?.productRatingCount.toString() ?? '0'} Rating and Reviews',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        offerDetail.value?.specifications ?? "",
                        style: TextStyle(height: 1.5, color: Colors.black54),
                      ),

                      const SizedBox(height: 20),

                      // About
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'About this item:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        offerDetail.value?.description ?? '',
                        style: TextStyle(height: 1.5, color: Colors.black54),
                      ),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Terms & Conditions:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        offerDetail.value?.termsAndConditions ?? '',
                        style: TextStyle(height: 1.5, color: Colors.black54),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
