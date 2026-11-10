
import 'package:flutter/material.dart';

class Experiment2A extends StatelessWidget {
  const Experiment2A({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar UI Widgets'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'My Calendar App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'November 2026',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Image.network(
              'https://picsum.photos/300/120',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 80);
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Upcoming Event: Project Review',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
