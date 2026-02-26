import 'package:flutter/material.dart';
import '../data/travel_data.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class AllDestinationsScreen extends StatelessWidget {
  const AllDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Places"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: destinations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final d = destinations[index];

          // Card-like list item using DestinationCard but with fixed height
          return SizedBox(
            height: 220,
            child: DestinationCard(
              destination: d,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(destination: d)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}