import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  void addContact(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(hintText: "Name")),
            TextField(controller: phone, decoration: const InputDecoration(hintText: "Phone")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseService.addContact(name.text, phone.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Contacts")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addContact(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.contacts.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              var d = docs[i];

              return ListTile(
                title: Text(d['name']),
                subtitle: Text(d['phone']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    FirebaseService.deleteContact(d.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}