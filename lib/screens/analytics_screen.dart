import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<Map<String, dynamic>> getStats() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('vehicles').get();

    int totalVehicles = snapshot.docs.length;
    int totalComplaints = 0;
    int totalReports = 0;

    List<Map<String, dynamic>> riskyVehicles = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();

      int complaints = data['complaints'] ?? 0;
      List reporters = data['reported_by'] ?? [];

      totalComplaints += complaints;
      totalReports += reporters.length;

      if ((data['rating'] ?? 5) < 3) {
        riskyVehicles.add(data);
      }
    }

    riskyVehicles.sort((a, b) =>
        (a['complaints'] ?? 0).compareTo(b['complaints'] ?? 0));

    riskyVehicles = riskyVehicles.reversed.take(5).toList();

    return {
      "vehicles": totalVehicles,
      "complaints": totalComplaints,
      "reports": totalReports,
      "risky": riskyVehicles,
    };
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Analytics"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  "Overview 📊",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    statCard("Vehicles", data['vehicles'].toString(),
                        Icons.directions_car),
                    statCard("Complaints", data['complaints'].toString(),
                        Icons.report),
                    statCard("Reports", data['reports'].toString(),
                        Icons.people),
                    statCard("Risky Vehicles",
                        data['risky'].length.toString(), Icons.warning),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Top Risky Vehicles 🚨",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...data['risky'].map<Widget>((v) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v['number_plate'] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text("Complaints: ${v['complaints']}"),
                        Text("Rating: ${v['rating']}"),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}