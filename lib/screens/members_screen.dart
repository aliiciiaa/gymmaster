import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  late Future<List<Map<String, String>>> athletes;
  List<Map<String, String>> allAthletes = [];
  List<Map<String, String>> filteredAthletes = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    athletes = fetchAthletes();
  }

  // ---------------- FETCH ATHLETES (TEXTE PUR) ----------------
  Future<List<Map<String, String>>> fetchAthletes() async {
    final url = Uri.parse("http://localhost/gymapi/get_athletes.php");
    final response = await http.get(url);

    final body = response.body.trim();
    if (body == "EMPTY") return [];

    List<Map<String, String>> list = [];

    for (String line in body.split("\n")) {
      final p = line.split(";");

      list.add({
        "id": p[0],
        "first_name": p[1],
        "last_name": p[2],
        "gender": p[3],
        "birth_date": p[4],
        "phone": p[5],
        "image": p[6],
      });
    }

    allAthletes = list;
    filteredAthletes = list;

    return list;
  }

  // --------------- SEARCH FUNCTION ----------------
  void filterSearch(String text) {
    text = text.toLowerCase();
    setState(() {
      filteredAthletes = allAthletes.where((a) {
        final name = "${a['first_name']} ${a['last_name']}".toLowerCase();
        return name.contains(text);
      }).toList();
    });
  }

  // ---------------- API HELPERS → PARSE TEXTE ----------------
  Future<List<Map<String, String>>> fetchSubscriptions(int id) async {
    final res = await http
        .get(Uri.parse("http://localhost/gymapi/get_subscriptions.php?id=$id"));

    final body = res.body.trim();
    if (body == "EMPTY") return [];

    List<Map<String, String>> list = [];

    for (String line in body.split("\n")) {
      final p = line.split(";");
      list.add({
        "name": p[0],
        "start_date": p[1],
        "end_date": p[2],
        "amount_paid": p[3],
      });
    }

    return list;
  }

  Future<List<Map<String, String>>> fetchPayments(int id) async {
    final res = await http
        .get(Uri.parse("http://localhost/gymapi/get_payments.php?id=$id"));

    final body = res.body.trim();
    if (body == "EMPTY") return [];

    List<Map<String, String>> list = [];

    for (String line in body.split("\n")) {
      final p = line.split(";");
      list.add({"amount": p[0], "payment_date": p[1]});
    }

    return list;
  }

  Future<List<Map<String, String>>> fetchLogs(int id) async {
    final res =
        await http.get(Uri.parse("http://localhost/gymapi/get_logs.php?id=$id"));

    final body = res.body.trim();
    if (body == "EMPTY") return [];

    List<Map<String, String>> list = [];

    for (String line in body.split("\n")) {
      final p = line.split(";");
      list.add({"status": p[0], "access_time": p[1]});
    }

    return list;
  }

  // -------------------------------------------------------------------
  // ----------------------- ADD ATHLETE FORM --------------------------
  // -------------------------------------------------------------------
File? selectedImage;
String base64Image = "";
final ImagePicker picker = ImagePicker();

  void openAddAthleteForm() {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final rfid = TextEditingController();
  final amountPaid = TextEditingController();

  String? gender;
  DateTime? birthDate;
  File? selectedImage;
String base64Image = "";
final ImagePicker picker = ImagePicker();

// Pour le formulaire
String? selectedSubscription;
String? paymentStatus;
final subscriptionOptions = [
  "Monthly Basic - 3,000 DA",
  "Monthly Premium - 5,000 DA",
  "Quarterly Basic - 8,000 DA",
  "Quarterly Premium - 12,000 DA",
  "Annual Basic - 30,000 DA",
  "Annual Premium - 45,000 DA",
  "Student Monthly - 2,000 DA",
  "Senior Monthly - 2,500 DA",
];
final paymentStatusOptions = ["Paid", "Partial", "Unpaid"];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Add New Athlete",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                Center(
  child: GestureDetector(
    onTap: () async {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        selectedImage = File(picked.path);
        base64Image = base64Encode(selectedImage!.readAsBytesSync());
        setState(() {});
      }
    },
    child: CircleAvatar(
      radius: 45,
      backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
      child: selectedImage == null
          ? Icon(Icons.camera_alt, size: 32)
          : null,
    ),
  ),
),

                  const SizedBox(height: 25),

                  TextField(
                    controller: rfid,
                    decoration: InputDecoration(labelText: "RFID Card Number"),
                  ),

                  TextField(
                    controller: firstName,
                    decoration: InputDecoration(labelText: "First Name"),
                  ),

                  TextField(
                    controller: lastName,
                    decoration: InputDecoration(labelText: "Last Name"),
                  ),

                  TextField(
                    controller: phone,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Gender"),
                    items: ["Male", "Female"]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    value: gender,
                    onChanged: (v) => setState(() => gender = v),
                  ),

                  const SizedBox(height: 15),

                  // ---------------- Date of Birth ----------------
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Date of Birth",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    ),
    const SizedBox(height: 5),
    GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => birthDate = picked);
        }
      },
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          birthDate == null
              ? "Pick a date"
              : birthDate.toString().split(" ")[0],
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  ],
),


                  const SizedBox(height: 20),

               // *** Type d'abonnement Dropdown ***
// Dropdown pour l'abonnement
DropdownButtonFormField<String>(
  decoration: InputDecoration(labelText: "Subscription"),
  items: subscriptionOptions
      .map((sub) => DropdownMenuItem(value: sub, child: Text(sub)))
      .toList(),
  value: selectedSubscription,
  onChanged: (v) => setState(() => selectedSubscription = v),
),

const SizedBox(height: 15),

// Dropdown pour le statut du paiement
DropdownButtonFormField<String>(
  decoration: InputDecoration(labelText: "Payment Status"),
  items: paymentStatusOptions
      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
      .toList(),
  value: paymentStatus,
  onChanged: (v) => setState(() => paymentStatus = v),
),


const SizedBox(height: 15),


                  // *** AJOUT Amount Paid TextField ***
                  TextField(
                    controller: amountPaid,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount Paid (DA)",
                      suffixText: "DA",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: Text("Save Athlete"),
                          onPressed: () async {
  // Ajouter l'athlète
  final athleteId = await addAthlete(
    firstName.text,
    lastName.text,
    gender ?? "",
    birthDate != null ? birthDate.toString().split(" ")[0] : "",
    phone.text,
    base64Image,
    rfid.text,
  );

  if (athleteId != null && selectedSubscription != null) {
    // Extraire subscription_id et prix depuis le texte du Dropdown
    final parts = selectedSubscription!.split(" - ");
    final subscriptionName = parts[0];
    final amount = parts[1].replaceAll(" DA", "").replaceAll(",", "");

    // Ajouter dans athlete_subscriptions
    await addAthleteSubscription(
      athleteId,
      subscriptionName,
      paymentStatus ?? "Unpaid",
      int.tryParse(amount) ?? 0,
    );

    // Ajouter dans payments si payé
    if (paymentStatus == "Paid" || paymentStatus == "Partial") {
      await addPayment(athleteId, int.tryParse(amount) ?? 0);
    }
  }

  Navigator.pop(context);
  setState(() {
    athletes = fetchAthletes();
  });
},

                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  // ------------------ SEND DATA TO API ------------------
 Future<String?> addAthlete(
  String first,
  String last,
  String gender,
  String birth,
  String phone,
  String image,
  String rfid,
) async {
  final url = Uri.parse("http://localhost/gymapi/add_athlete.php");

  final res = await http.post(url, body: {
    "first_name": first,
    "last_name": last,
    "gender": gender,
    "birth_date": birth,
    "phone": phone,
    "image": image,
    "rfid": rfid,
  });

  print("API RESPONSE: ${res.body}");

  // Suppose que le PHP renvoie l'ID du nouvel athlète en texte pur
  if (res.body.contains("success")) {
    final match = RegExp(r'id:(\d+)').firstMatch(res.body);
    return match != null ? match.group(1) : null;
  }

  return null;
}
Future<void> addAthleteSubscription(
  String athleteId,
  String subscriptionName,
  String status,
  int amountPaid,
) async {
  final url = Uri.parse("http://localhost/gymapi/add_athlete_subscription.php");
  await http.post(url, body: {
    "athlete_id": athleteId,
    "subscription_name": subscriptionName,
    "status": status,
    "amount_paid": amountPaid.toString(),
  });
}

Future<void> addPayment(String athleteId, int amount) async {
  final url = Uri.parse("http://localhost/gymapi/add_payment.php");
  await http.post(url, body: {
    "athlete_id": athleteId,
    "amount": amount.toString(),
    "method": "Cash",
    "type": "Subscription",
    "reference": "",
  });
}


  // -------------------------------------------------------------------
  // ----------------------- ATHLETE DETAILS POPUP ----------------------
  // -------------------------------------------------------------------

  void openDetailsPopup(dynamic a) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final fullName = "${a['first_name']} ${a['last_name']}";

        return DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: a['image'] != null &&
                          a['image'].toString().isNotEmpty
                      ? NetworkImage(a['image'])
                      : null,
                  child: a['image'] == null ? Text(a['first_name'][0]) : null,
                ),

                const SizedBox(height: 10),

                Text(fullName,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                Text("Phone: ${a['phone']}"),

                const SizedBox(height: 20),

                const TabBar(
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  tabs: [
                    Tab(text: "Subscriptions"),
                    Tab(text: "Payments"),
                    Tab(text: "Logs"),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      // SUBSCRIPTIONS
                      FutureBuilder(
                        future: fetchSubscriptions(int.parse(a['id'])),
                        builder: (context, snap) {
                          if (!snap.hasData)
                            return Center(child: CircularProgressIndicator());
                          final subs = snap.data!;
                          return ListView.builder(
                            itemCount: subs.length,
                            itemBuilder: (_, i) {
                              final s = subs[i];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text("${s['name']}"),
                                  subtitle: Text(
                                      "${s['start_date']} → ${s['end_date']}"),
                                  trailing: Text("${s['amount_paid']} DA"),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      // PAYMENTS
                      FutureBuilder(
                        future: fetchPayments(int.parse(a['id'])),
                        builder: (context, snap) {
                          if (!snap.hasData)
                            return Center(child: CircularProgressIndicator());
                          final pay = snap.data!;
                          return ListView.builder(
                            itemCount: pay.length,
                            itemBuilder: (_, i) {
                              final p = pay[i];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text("${p['amount']} DA"),
                                  subtitle: Text("Date: ${p['payment_date']}"),
                                  leading: Icon(Icons.payments),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      // LOGS
                      FutureBuilder(
                        future: fetchLogs(int.parse(a['id'])),
                        builder: (context, snap) {
                          if (!snap.hasData)
                            return Center(child: CircularProgressIndicator());
                          final logs = snap.data!;
                          return ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (_, i) {
                              final l = logs[i];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Icon(Icons.access_time),
                                  title: Text(l['status'] ?? ""),
                                  subtitle: Text(l['access_time'] ?? ""),

                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // -------------------------- MAIN WIDGET -----------------------------
  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Members")),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddAthleteForm,
        child: Icon(Icons.add),
      ),

      body: FutureBuilder<List<Map<String, String>>>(
        future: athletes,
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ---------------- SEARCH BAR ----------------
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearch,
                  decoration: InputDecoration(
                    hintText: "Search by name...",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // ---------------- LIST ----------------
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAthletes.length,
                  itemBuilder: (_, i) {
                    final a = filteredAthletes[i];
                    final name = "${a['first_name']} ${a['last_name']}";

                    return Card(
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                       leading: CircleAvatar(
  radius: 25,
  backgroundImage: (a['image'] != null && a['image']!.isNotEmpty)
      ? NetworkImage(a['image']!)
      : null,
  child: (a['image'] == null || a['image']!.isEmpty)
      ? Text(a['first_name']![0])
      : null,
),

                        title: Text(name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(a['phone'] ?? ""),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => openDetailsPopup(a),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
