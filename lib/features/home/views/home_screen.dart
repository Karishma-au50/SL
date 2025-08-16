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
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: NetworkImageView(
                      imgUrl:
                          "https://i.pinimg.com/736x/4c/53/91/4c5391c2a69855120a204971a728f421.jpg",
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        // use decoded token for user name or user details
                        userDetails?.displayName ??
                            (user.firstname != null
                                ? '${user.firstname} ${user.lastname}'
                                : 'Guest'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(AppRoutes.language);
                      // StorageService.instance.clear();
                    },
                    icon: const Icon(Icons.language, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
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
                aspectRatio: 20 / 9,
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
            const SizedBox(height: 16),

            // Top Actions
            Container(
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
              child: Padding(
                padding: const EdgeInsets.all(6.0),
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
                                _actionBox(
                                  Icons.qr_code_scanner,
                                  'Scan Product',
                                ),
                                Spacer(),
                                _actionBox(Icons.chat, 'Chat with us'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle redeem points tap
                                context.push(AppRoutes.redeemPoints);
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 24,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDF3F4),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.kcPrimaryColor
                                          .withOpacity(0.1),
                                      child: Icon(
                                        Icons.card_giftcard,
                                        size: 18,
                                        color: AppColors.kcPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Redeem MY Plus\nPoints',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                        _iconCircle('Gift\nTracker', Icons.redeem, () {
                          context.push(AppRoutes.redeemPoints);
                        }),
                        _iconCircle('Company\nPolicy', Icons.policy, () {
                          context.push(AppRoutes.companyPolicy);
                        }),
                        _iconCircle('SLC\nVideo', Icons.ondemand_video, () {
                          context.push(AppRoutes.slcVideo);
                        }),
                        _iconCircle('About\nus', Icons.info_outline, () {
                          context.push(AppRoutes.aboutUs);
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Points Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001519),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      const Text(
                                        'Available Points (1 Point = ₹1)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/boy.png',
                                    width: 80,
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
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Get it Now Withdraw'),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Redeem Points',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push(
                                      AppRoutes.redeemHistory,
                                      extra: userRedeemHistory,
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: AppColors.kcPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Redeem List Items
                          _redeemTile(userRedeemHistory!),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBox(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Scan Product') {
          context.push(AppRoutes.qrScan);
        } else if (title == 'Chat with us') {
          context.push(AppRoutes.chatWithUs);
        }
        // Add more actions as needed
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF3F4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.kcPrimaryColor.withOpacity(0.1),
              child: Icon(icon, size: 18, color: AppColors.kcPrimaryColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(String title, IconData icon, void Function()? callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(
            color: AppColors.kcPrimaryColor.withOpacity(0.2),
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
            color: const Color(0xFFFDF3F4), // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(45),

            // boxShadow: [BoxShadow(color: const Color(0xFFFDF3F4), blurRadius: 6)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: AppColors.kcPrimaryColor),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
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
      itemCount: 2,
      itemBuilder: (context, index) {
        final redemption = redeemHistory.recentRedemptions![index];
        final name = userDetails?.fullName ?? 'No Name';
        final date = redemption.completedAt ?? '';
        final points = redemption.pointsEarned?.toString() ?? '0';
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          leading: Image.asset(
            "assets/images/defaultProductLogo.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            DateFormators.formatDate(
              DateTime.tryParse(date.toString()) ?? DateTime.now(),
            ),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Poppins'),
              children: [
                TextSpan(
                  text: '$points ',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                WidgetSpan(
                  child: Icon(Icons.arrow_outward, size: 14, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
