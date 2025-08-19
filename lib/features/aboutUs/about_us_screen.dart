import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:sl/features/home/controller/dashboard_controller.dart';
import 'package:sl/shared/typography.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late Map<String, dynamic> aboutUsData;

  LatLng? mapCoords;

  @override
  void initState() {
    super.initState();
    loadDummyData();
  }

  void loadDummyData() async {
    aboutUsData = {};
    DashboardController controller = Get.find<DashboardController>();

    final data = await controller.getAboutUsDetails();
    aboutUsData = data;
    setState(() {});

    // Fetch coordinates for map
    if (aboutUsData["visitUs"] != null &&
        aboutUsData["visitUs"].toString().isNotEmpty) {
      final coords = await _getLatLonFromAddress(aboutUsData["visitUs"]);
      if (coords != null) {
        setState(() {
          mapCoords = LatLng(coords[0], coords[1]);
        });
      } else {
        setState(() {
          mapCoords = LatLng(28.5375805, 77.3446986); // fallback default
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001519),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001519),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "About Us",
          style: AppTypography.heading6(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: aboutUsData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/unionBlack.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...aboutUsData["description"].map<Widget>((text) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Html(data: text),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    mapCoords == null
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 300,
                            child: fmap.FlutterMap(
                              options: fmap.MapOptions(
                                initialCenter: mapCoords!,
                                initialZoom: 15,
                              ),
                              children: [
                                fmap.TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                  userAgentPackageName: 'com.example.app',
                                ),
                                fmap.MarkerLayer(
                                  markers: [
                                    fmap.Marker(
                                      point: mapCoords!,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 16),
                    _contactInfo(Icons.location_on, aboutUsData["visitUs"]),
                    const SizedBox(height: 12),
                    _contactInfo(Icons.email, aboutUsData["email"]),
                    const SizedBox(height: 12),
                    _contactInfo(Icons.phone, aboutUsData["phone"]),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _contactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF00BFA5)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
        ),
      ],
    );
  }

  Future<List<double>?> _getLatLonFromAddress(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        'https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final results = json.decode(res.body);
        if (results is List && results.isNotEmpty) {
          final lat = double.tryParse(results[0]["lat"]);
          final lon = double.tryParse(results[0]["lon"]);
          if (lat != null && lon != null) {
            return [lat, lon];
          }
        }
      }
    } catch (e) {
      // ignore errors, fallback to no map
    }
    return null;
  }
}
