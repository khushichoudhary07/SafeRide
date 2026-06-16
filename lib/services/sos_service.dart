import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_service.dart';

class SOSService {
  static Future<void> sendSOS() async {
    try {
      var snapshot = await FirebaseService.contacts.get();

      if (snapshot.docs.isEmpty) return;

      LocationPermission permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();

      String msg =
          "🚨 EMERGENCY ALERT 🚨\nhttps://maps.google.com/?q=${pos.latitude},${pos.longitude}";

      List<String> numbers = [];

      for (var doc in snapshot.docs) {
        numbers.add(doc['phone']);
      }

      String allNumbers = numbers.join(',');

      Uri uri = Uri.parse(
        "sms:$allNumbers?body=${Uri.encodeComponent(msg)}",
      );

      await launchUrl(uri);
    } catch (e) {
      print("SOS Error: $e");
    }
  }
}