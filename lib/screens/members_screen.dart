import 'package:flutter/material.dart';
import '../models/athlete.dart';
import '../services/api_service.dart';
import '../widgets/athlete_card.dart';
import '../dialogs/add_athlete_dialog.dart';
import '../theme/app_colors.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Athlete> _athletes = [];
  List<Athlete> _filtered = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_applyFilter);
  }

  Future _load() async {
    try {
      final list = await ApiService.getAthletes();
      setState(() {
        _athletes = list;
        _filtered = List.from(list);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase();

    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_athletes);
      } else {
        _filtered = _athletes.where((a) {
          final name =
              (a.firstName + " " + a.lastName).toLowerCase();
          final sub = (a.subscriptionName ?? '').toLowerCase();
          return name.contains(q) || sub.contains(q);
        }).toList();
      }
    });
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) =>
          AddAthleteDialog(onSaved: () => _load()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _athletes
        .where((a) => a.computedStatus.toLowerCase().contains("active"))
        .length;

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Athletes",
            style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.red700,
        onPressed: _openAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: "Search athletes...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text("${_athletes.length} athletes found"),
                Text("$activeCount active",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (context, i) {
                          final a = _filtered[i];
                          return AthleteCard(
                            name: "${a.firstName} ${a.lastName}",
                            subscription:
                                a.subscriptionName ?? "No Sub",
                            expires: a.endDate ?? "",
                            status: a.computedStatus,
                            imageUrl: a.image ?? "",
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
