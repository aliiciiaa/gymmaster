import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple placeholder list you can connect to DB later
    final members = List.generate(12, (i) => 'Member ${i + 1}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(members[index]),
              subtitle: const Text('Subscription active'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
