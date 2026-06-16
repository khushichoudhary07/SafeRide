import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/sos_service.dart';
import '../services/auth_service.dart';
import 'contacts_screen.dart';
import 'submit_vehicle_screen.dart';
import 'analytics_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  Map<String, dynamic>? data;
  bool isLoading = false;

  // 🔍 SEARCH
  Future<void> search() async {
    setState(() => isLoading = true);

    var doc = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(controller.text.trim().toUpperCase())
        .get();

    if (doc.exists) {
      data = doc.data();
    } else {
      data = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle not verified")),
      );
    }

    setState(() => isLoading = false);
  }

  // 📸 SCAN
  Future<void> scan() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img == null) return;

    final text = await TextRecognizer()
        .processImage(InputImage.fromFilePath(img.path));

    controller.text =
        text.text.replaceAll(RegExp(r'[^A-Z0-9]'), '').toUpperCase();

    search();
  }

  // 🎨 HELPERS
  Color getColor(double r) {
    if (r >= 4) return Colors.green;
    if (r >= 3) return Colors.orange;
    return Colors.red;
  }

  String getLabel(double r) {
    if (r >= 4) return "Safe";
    if (r >= 3) return "Caution";
    return "Risky";
  }

  // 🔐 LOGOUT
  Future<void> logout() async {
    await AuthService.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // 🧊 MODERN CARD
  Widget modernCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black12,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // 🚨 SOS
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: SOSService.sendSOS,
        icon: const Icon(Icons.warning),
        label: const Text("SOS"),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔥 HERO HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B6CFF), Color(0xFF8E54E9)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SafeRide",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Stay Safe on Roads 🚗",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔍 SEARCH
            modernCard(
              Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Enter Vehicle Number",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: search,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Search"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: scan,
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Scan"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ⚡ ACTIONS
            modernCard(
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ContactsScreen()),
                      );
                    },
                    icon: const Icon(Icons.people),
                    label: const Text("Emergency Contacts"),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SubmitVehicleScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Submit Vehicle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize:
                          const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const AnalyticsScreen()),
                      );
                    },
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("Analytics Dashboard"),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),

            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            // 📊 RESULT CARD
            if (data != null)
              modernCard(
                Builder(builder: (context) {
                  double rating = data!['rating'] ?? 5.0;
                  List reportedBy = data!['reported_by'] ?? [];
                  int reporters = reportedBy.length;

                  final uid =
                      FirebaseAuth.instance.currentUser!.uid;

                  bool alreadyReported =
                      reportedBy.contains(uid);

                  return Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        data!['driver_name'] ??
                            "Unknown Driver",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          "Plate: ${data!['number_plate']}"),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: getColor(rating)
                                  .withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                              getLabel(rating),
                              style: TextStyle(
                                  color: getColor(rating),
                                  fontWeight:
                                      FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "⭐ $rating",
                            style: TextStyle(
                                color: getColor(rating),
                                fontWeight:
                                    FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                          "Complaints: ${data!['complaints']}"),
                      Text("Reported by $reporters users"),

                      if (alreadyReported)
                        Container(
                          margin:
                              const EdgeInsets.only(top: 8),
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),
                          child: const Text(
                            "✔ You already reported this vehicle",
                            style: TextStyle(
                                color: Colors.blue),
                          ),
                        ),

                      if (rating < 3)
                        Container(
                          margin:
                              const EdgeInsets.only(
                                  top: 10),
                          padding:
                              const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),
                          child: const Text(
                            "⚠ High risk vehicle. Stay alert.",
                            style: TextStyle(
                                color: Colors.red),
                          ),
                        ),
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}