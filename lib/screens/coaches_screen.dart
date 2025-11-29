import 'package:flutter/material.dart';

class CoachesScreen extends StatelessWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaches = ['Wahab Harici', 'Sarah Lee', 'Mike Davis'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaches'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: coaches.length,
          itemBuilder:
              (context, idx) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(child: Text(coaches[idx][0])),
                  title: Text(coaches[idx]),
                  subtitle: const Text('Specialization: Strength'),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {},
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
