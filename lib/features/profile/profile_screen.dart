import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/user_detail_model.dart';
import '../../routes/app_routes.dart';
import '../../shared/services/common_service.dart';
import '../../shared/services/storage_service.dart';
import '../../widgets/inputs/my_text_field.dart';
import '../../widgets/toast/my_toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDetailModel? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final details = await CommonService.to.getUserDetails();
      if (mounted) {
        setState(() {
          userDetails = details;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        MyToasts.toastError("Failed to load user details: ${e.toString()}");
      }
    }
  }

  Future<void> _logout() async {
    try {
      // Clear storage
      await StorageService.instance.clear();

      if (mounted) {
        MyToasts.toastSuccess("Logged out successfully");
        // Navigate to login screen
        context.go(AppRoutes.login);
      }
    } catch (e) {
      MyToasts.toastError("Error during logout: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadUserDetails();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout();
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            userDetails?.imageURL.isNotEmpty == true
                            ? NetworkImage(userDetails!.imageURL.first)
                            : const AssetImage("assets/images/Union.png")
                                  as ImageProvider,
                        child: userDetails?.imageURL.isEmpty == true
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // User Details
                    _buildTextField("First Name", userDetails?.firstname ?? ""),
                    _buildTextField(
                      "Middle Name",
                      userDetails?.middlename ?? "",
                    ),
                    _buildTextField("Last Name", userDetails?.lastname ?? ""),
                    _buildTextField(
                      "Date of Birth",
                      _formatDate(userDetails?.dob),
                    ),
                    _buildTextField("Phone Number", _formatPhoneNumber()),
                    _buildTextField("Email Address", userDetails?.email ?? ""),
                    _buildTextField("Gender", userDetails?.gender ?? ""),
                    _buildTextField("Address", _formatAddress()),
                    _buildTextField("City", userDetails?.city ?? ""),
                    _buildTextField("State", userDetails?.state ?? ""),
                    _buildTextField("Pincode", userDetails?.pincode ?? ""),
                    _buildTextField("Country", userDetails?.country ?? ""),

                    const SizedBox(height: 24),

                    // Document Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Document Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentInfo(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Account Information (if available)
                    if (userDetails?.savedAccountDetails != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Saved Account Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // _buildAccountInfo(),
                          ],
                        ),
                      ),

                    if (userDetails?.savedAccountDetails != null)
                      const SizedBox(height: 24),

                    // Points Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Points Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Available Points:"),
                              Text(
                                "${userDetails?.availablePoints ?? 0}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Points:"),
                              Text(
                                "${userDetails?.totalPoints ?? 0}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Redeemed Points:"),
                              Text(
                                "${userDetails?.redeemedPoints ?? 0}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // Add some bottom padding
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatAddress() {
    List<String> addressParts = [
      userDetails?.address1 ?? "",
      userDetails?.address2 ?? "",
      userDetails?.address3 ?? "",
    ].where((part) => part.trim().isNotEmpty).toList();

    return addressParts.isEmpty ? "" : addressParts.join(", ");
  }

  String _formatPhoneNumber() {
    if (userDetails?.mobile == null || userDetails!.mobile == 0) {
      return "";
    }
    return userDetails!.mobile.toString();
  }

  Widget _buildTextField(String? label, String? hint) {
    // Show "N/A" if hint is null, empty, or only whitespace
    String displayValue = (hint?.trim().isEmpty ?? true) ? "N/A" : hint!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyTextField(
        hintText: displayValue,
        labelText: label ?? "",
        hindStyle: TextStyle(
          color: displayValue == "N/A" ? Colors.grey : Colors.black,
          fontStyle: displayValue == "N/A"
              ? FontStyle.italic
              : FontStyle.normal,
        ),
        isReadOnly:
            true, // Make fields read-only since this is a display screen
      ),
    );
  }

  Widget _buildDocumentInfo() {
    if (userDetails?.documentsName == null ||
        userDetails!.documentsName.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "No documents uploaded",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < userDetails!.documentsName.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getDocumentIcon(userDetails!.documentsName[i]),
                      color: const Color(0xFF001519),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDetails!.documentsName[i].isNotEmpty
                                ? userDetails!.documentsName[i]
                                : "Document ${i + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Document Number: ${i < userDetails!.documentsDetails.length && userDetails!.documentsDetails[i].isNotEmpty ? userDetails!.documentsDetails[i] : 'N/A'}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Show verification status
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: userDetails!.isVerified
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    userDetails!.isVerified
                        ? "Verified"
                        : "Pending Verification",
                    style: TextStyle(
                      color: userDetails!.isVerified
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  IconData _getDocumentIcon(String documentType) {
    String docType = documentType.toLowerCase();
    if (docType.contains('pan')) {
      return Icons.credit_card;
    } else if (docType.contains('aadhar') || docType.contains('aadhaar')) {
      return Icons.fingerprint;
    } else if (docType.contains('passport')) {
      return Icons.card_travel;
    } else if (docType.contains('license') || docType.contains('driving')) {
      return Icons.directions_car;
    } else if (docType.contains('voter')) {
      return Icons.how_to_vote;
    } else {
      return Icons.description;
    }
  }
}
