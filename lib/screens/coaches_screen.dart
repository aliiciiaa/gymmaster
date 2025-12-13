import 'package:flutter/material.dart';
import '../models/coach.dart';
import '../services/api_service.dart';
import '../widgets/coach_card.dart';

class CoachesScreen extends StatefulWidget {
  const CoachesScreen({super.key});

  @override
  State<CoachesScreen> createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  List<Coach> _coaches = [];
  List<Coach> _filtered = [];
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
      final list = await ApiService.getCoaches();
      setState(() {
        _coaches = list;
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
        _filtered = List.from(_coaches);
      } else {
        _filtered = _coaches.where((c) {
          final name = c.fullName.toLowerCase();
          final role = c.role.toLowerCase();
          return name.contains(q) || role.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final averageAttendance = _coaches.isNotEmpty
        ? _coaches
            .map((c) => c.attendanceRate ?? 0)
            .reduce((a, b) => a + b) ~/ _coaches.length
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Coaches",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _load,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: "Search coaches...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),
            
            // STATS ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_coaches.length} coaches found",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: _getAttendanceColor(averageAttendance),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Avg: $averageAttendance%",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // COACHES LIST
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: _filtered.isEmpty
                          ? const Center(
                              child: Text(
                                "No coaches found",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filtered.length,
                              itemBuilder: (context, i) {
                                final coach = _filtered[i];
                                return CoachCard(
                                  name: coach.fullName,
                                  role: coach.role,
                                  phone: coach.phone,
                                  hireDate: coach.hireDate,
                                  salary: coach.salary,
                                  imageUrl: coach.image,
                                  attendanceRate: coach.attendanceRate,
                                  yearsService: coach.yearsService,
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

  Color _getAttendanceColor(int rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 80) return Colors.orange;
    return Colors.red;
  }
}