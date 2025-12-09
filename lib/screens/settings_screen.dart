import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
class SettingsScreen extends StatefulWidget {
  final int userId;

  const SettingsScreen({super.key, required this.userId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  String firstName = "";
  String lastName = "";
  String gymName = "";
  String email = "";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
  }

  Future<void> fetchSettingsData() async {
  try {
    final url = Uri.parse(
        "http://localhost/gymapi/settings.php?id=${widget.userId}");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      if (data["status"] == "success") {
        final user = data["user"];

        setState(() {
          firstName = user["nom"];
          lastName = user["prenom"];
          gymName = user["salle_sport"];
          email = user["email"];
          loading = false;
        });
      }
    }
  } catch (e) {
    print("Erreur: $e");
  }
}


  // Popup changer mot de passe
  void changePasswordPopup() {
    TextEditingController oldCtrl = TextEditingController();
    TextEditingController newCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Changer mot de passe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              decoration: const InputDecoration(labelText: "Ancien mot de passe"),
            ),
            TextField(
              controller: newCtrl,
              decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
  onPressed: () async {
    final oldPass = oldCtrl.text.trim();
    final newPass = newCtrl.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty) return;

    final url = Uri.parse("http://localhost/gymapi/change_password.php");
    try {
      final res = await http.post(url, body: {
        "userId": widget.userId.toString(),
        "oldPassword": oldPass,
        "newPassword": newPass,
      });

      final data = json.decode(res.body);

      Navigator.pop(context); // fermer le popup

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
          backgroundColor: data["status"] == "success" ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur réseau."),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: const Text("Confirmer"),
),

        ],
      ),
    );
  }

  // Popup notifications
  void notificationPopup() {
    bool enableNotif = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSB) => AlertDialog(
          title: const Text("Notifications"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Activer notifications"),
              Switch(
                value: enableNotif,
                onChanged: (v) => setStateSB(() => enableNotif = v),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer")),
          ],
        ),
      ),
    );
  }

  // Popup contact
  void contactPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact"),
        content: const Text("Email support : support@gymmaster.com"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // HEADER carré
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        gymName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==== OPTIONS ====
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Changer mot de passe"),
                  onTap: changePasswordPopup,
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  onTap: notificationPopup,
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support),
                  title: const Text("Contact"),
                  onTap: contactPopup,
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => false);
                  },
                ),
              ],
            ),
    );
  }
}
