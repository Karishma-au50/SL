import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/features/auth/controller/auth_controller.dart';
import 'package:sl/features/chatWithUs/chat_with_us_screen.dart';
import 'package:sl/features/home/controller/dashboard_controller.dart';
import 'package:sl/model/user_detail_model.dart';
import 'package:sl/model/user_model.dart';
import 'package:sl/routes/app_routes.dart';
import 'package:sl/shared/typography.dart';

import '../../../model/home_banner_model.dart';
import '../../../model/user_redeem_history_model.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/services/common_service.dart';
import '../../../shared/services/storage_service.dart' show StorageService;
import '../../../shared/utils/date_formators.dart' show DateFormators;
import '../../../widgets/network_image_view.dart';
import '../../../widgets/toast/my_toast.dart';
import '../../myPoints/views/all_offers_screen.dart';
import '../../profile/profile_screen.dart';
import '../../wallet/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserModel user;
  UserDetailModel? userDetails;
  int current = 0;
  final List<HomeBannerModel> homeBanner = [];
  UserRedeemHistoryModel? userRedeemHistory;
  bool isLoadingUserDetails = true;

  DashboardController dashboardController =
      Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    user = StorageService.instance.getUserId() ?? UserModel();
    _loadData();
    _loadUserRedeemHistory();
  }

  Future<void> _loadData() async {
    // Load banners
    dashboardController.getHomeScreenBanner().then((offers) {
      if (offers != null) {
        setState(() {
          homeBanner.addAll(offers);
        });
      }
    });

    _loadUserDetails();
  }

  _loadUserDetails() async {
    // Load user details if user ID exists
    if (user.id?.isNotEmpty == true) {
      final details = await CommonService.to.getUserDetails();
      if (mounted) {
        setState(() {
          userDetails = details;
          isLoadingUserDetails = false;
        });
      }
    } else {
      setState(() {
        isLoadingUserDetails = false;
      });
    }
  }

  _loadUserRedeemHistory() async {
    if (user.id?.isNotEmpty == true) {
      try {
        final history = await authController.getRedemptionHistory(user.id!);
        if (mounted) {
          setState(() {
            // Update UI with redemption history
            userRedeemHistory = history;
            isLoadingUserDetails = false;
          });
        } else {
          setState(() {
            isLoadingUserDetails = false;
          });
        }
      } catch (e) {
        MyToasts.toastError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.profile, extra: userDetails);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: NetworkImageView(
                            imgUrl: user.profileImage,
                            radius: 24,
                            isFullPath: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to SLC',
                              style: AppTypography.bodySmall(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              // use decoded token for user name or user details
                              userDetails?.displayName ??
                                  (user.firstname != null
                                      ? '${user.firstname?.toUpperCase()} ${user.middlename?.toUpperCase()}'
                                      : 'Guest'),
                              style: AppTypography.labelLarge(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  InkWell(
                    onTap: () {
                      context.push(AppRoutes.wallet);
                      // StorageService.instance.clear();
                    },
                    child: Image.asset(
                      "assets/images/walletIcon.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      context.push(AppRoutes.notifications);
                    },
                    child: Image.asset(
                      "assets/images/notificationIcon.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 16),

            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CarouselSlider(
                  items: homeBanner.map((offer) {
                    return GestureDetector(
                      onTap: () {},
                      child: NetworkImageView(
                        imgUrl: offer.image,
                        radius: 8,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                    // limitedOffers.length >= 2 ? 0.8 : 1,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            // Dots Indicator
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: homeBanner.map((url) {
                  int index = homeBanner.indexOf(url);
                  bool isSelected = current == index;
                  return Container(
                    width: isSelected ? 16.0 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 2.0,
                    ),
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(4),
                      color: isSelected
                          ? AppColors.kcPrimaryColor
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Top Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: _actionBox(
                                  "assets/images/scanQr.png",
                                  'Scan Product',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _actionBox(
                                  "assets/images/chatWithUs.png",
                                  'Chat with us',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.push(AppRoutes.redeemPoints);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF3F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/redeemPoint.png",
                                    width: 26,
                                    height: 26,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Redeem My Plus\nPoints',
                                    style: AppTypography.labelLarge(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // More options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconCircle(
                        'Points\nHistory',
                        "assets/images/pointHistoryIcon.png",
                        () {
                          context.push(
                            AppRoutes.redeemHistory,
                            extra: userRedeemHistory,
                          );
                        },
                      ),
                      _iconCircle(
                        'Company\nPolicy',
                        "assets/images/companyPolicy.png",
                        () {
                          context.push(AppRoutes.companyPolicy);
                        },
                      ),
                      _iconCircle('SLC\nVideo', "assets/images/video.png", () {
                        context.push(AppRoutes.slcVideo);
                      }),
                      _iconCircle('About\nus', "assets/images/aboutUs.png", () {
                        context.push(AppRoutes.aboutUs);
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Points Card
                  Container(
                    height: 170.23,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001519),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("assets/images/withdrawBg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Available Points (1 Point = ₹1)',
                                      style: AppTypography.labelLarge(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _loadData,
                                      child: Icon(
                                        Icons.refresh,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                isLoadingUserDetails
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        '₹ ${userDetails?.availablePoints.toStringAsFixed(2) ?? '0.00'}',
                                        style: AppTypography.heading3(
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/boy.png',
                                  width: 100,
                                  height: 80,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.push(AppRoutes.withdrawPoints);

                              _loadUserDetails();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Get it Now Withdraw',
                              style: AppTypography.labelLarge(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (userRedeemHistory != null &&
                      userRedeemHistory!.recentRedemptions.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Redeem Points',
                              style: AppTypography.buttonLarge(),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(
                                  AppRoutes.redeemHistory,
                                  extra: userRedeemHistory,
                                );
                              },
                              child: Text(
                                'View All',
                                style: AppTypography.labelMedium(
                                  color: AppColors.kcPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Redeem List Items
                        _redeemTile(userRedeemHistory!),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBox(String image, String title) {
    return GestureDetector(
      onTap: () async {
        if (title == 'Scan Product') {
          await context.push(AppRoutes.qrScan);
          _loadUserDetails();
          // await  CommonService.to.getUserDetails(forceRefresh: true);
        } else if (title == 'Chat with us') {
          context.push(AppRoutes.chatWithUs);
        }
        // Add more actions as needed
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(image, width: 32, height: 32),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: AppTypography.labelLarge())),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(
    String title,
    String imagePath,
    void Function()? callback,
  ) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          border: BoxBorder.all(
            color: Color(0xFF5D546526).withOpacity(0.15),
            // width: 1,
          ),
          borderRadius: BorderRadius.circular(45),
        ),
        padding: const EdgeInsets.all(3.5),
        child: Container(
          width: 68,
          height: 85,
          // padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F2), // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(45),

            // boxShadow: [BoxShadow(color: const Color(0xFFFDF3F4), blurRadius: 6)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, width: 28, height: 28),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium(color: Color(0xFF1D1F22)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _redeemTile(UserRedeemHistoryModel redeemHistory) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: redeemHistory.recentRedemptions.length >= 3
          ? 3
          : redeemHistory.recentRedemptions.length,
      itemBuilder: (context, index) {
        final redemption = redeemHistory.recentRedemptions[index];
        final name = redemption.offerId.productId?.title ?? 'Product';
        final date = redemption.completedAt;
        final points = redemption.pointsEarned.toString();
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          leading: redemption.offerId.productId!.images.isNotEmpty
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: NetworkImageView(
                    imgUrl: redemption.offerId.productId!.images.first,
                    isFullPath: true,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3F2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/images/defaultProductLogo.png",
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
          title: Text(
            name,
            style: AppTypography.labelMedium(color: Color(0xFF1D1F22)),
          ),
          subtitle: Text(
            DateFormators.formatDate(
              DateTime.tryParse(date.toString()) ?? DateTime.now(),
            ),
            style: AppTypography.bodySmall(color: Color(0xFF747474)),
          ),
          trailing: RichText(
            text: TextSpan(
              style: AppTypography.labelMedium(),
              children: [
                TextSpan(
                  text: '$points ',
                  style: AppTypography.labelMedium(
                    color: AppColors.kcPrimaryColor,
                  ),
                ),
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3F2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_outward,
                      size: 12,
                      color: AppColors.kcPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
