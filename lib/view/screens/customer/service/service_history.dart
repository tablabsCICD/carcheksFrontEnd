import 'package:flutter/material.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service History"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.car_repair, color: Colors.green),
              title: Text("Service #${index + 1}"),
              subtitle: const Text("Completed successfully"),
              trailing: const Text("₹ 1200"),
            ),
          );
        },
      ),
    );
  }
}
