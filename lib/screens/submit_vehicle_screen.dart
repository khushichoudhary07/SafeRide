import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitVehicleScreen extends StatefulWidget {
  const SubmitVehicleScreen({super.key});

  @override
  State<SubmitVehicleScreen> createState() =>
      _SubmitVehicleScreenState();
}

class _SubmitVehicleScreenState extends State<SubmitVehicleScreen> {
  final plateController = TextEditingController();
  final nameController = TextEditingController();
  final complaintController = TextEditingController();

  bool isLoading = false;

  Future<void> submitVehicle() async {
    String plate = plateController.text.trim().toUpperCase();
    String name = nameController.text.trim();
    String complaint = complaintController.text.trim();

    if (plate.isEmpty) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? "unknown";

    var vehicleRef =
        FirebaseFirestore.instance.collection('vehicles').doc(plate);

    var submissionRef =
        FirebaseFirestore.instance.collection('user_submissions');

    var vehicleDoc = await vehicleRef.get();

    if (vehicleDoc.exists) {
      setState(() => isLoading = false);
      return;
    }

    var query = await submissionRef
        .where('number_plate', isEqualTo: plate)
        .get();

    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;

      List reportedBy = doc['reported_by'] ?? [];

      if (reportedBy.contains(userId)) {
        setState(() => isLoading = false);
        return;
      }

      reportedBy.add(userId);
      int reports = reportedBy.length;

      await submissionRef.doc(doc.id).update({
        'reported_by': reportedBy,
        'reports_count': reports,
      });

      if (reports >= 3) {
        await vehicleRef.set({
          'number_plate': plate,
          'driver_name': name,
          'complaints': reports,
          'rating': 5 - (reports * 0.5),
        });

        await submissionRef.doc(doc.id).delete();
      }
    } else {
      await submissionRef.add({
        'number_plate': plate,
        'driver_name': name,
        'complaint': complaint,
        'reported_by': [userId],
        'reports_count': 1,
      });
    }

    Navigator.pop(context);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Vehicle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: plateController),
            TextField(controller: nameController),
            TextField(controller: complaintController),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitVehicle,
                    child: const Text("Submit"),
                  ),
          ],
        ),
      ),
    );
  }
}