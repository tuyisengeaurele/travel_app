import 'package:flutter/material.dart';
import '../data/travel_data.dart';
import '../data/user_session.dart';
import '../models/destination.dart';
import '../widgets/category_chip.dart';
import '../widgets/destination_card.dart';
import 'all_destinations_screen.dart';
import 'detail_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  String searchQuery = "";

  List<Destination> get filteredDestinations {
    final selected = categories[selectedCategoryIndex];

    Iterable<Destination> list = destinations;

    // category filter
    if (selected != "Popular") {
      list = list.where((d) => d.category == selected);
    }

    // search filter
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.location.toLowerCase().contains(q) ||
            d.category.toLowerCase().contains(q);
      });
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            ValueListenableBuilder<AppUser?>(
              valueListenable: UserSession.user,
              builder: (context, user, _) {
                return Text(
                  user == null ? "Find your next trip" : "Hi, ${user.name} 👋",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Text(
              "Experience the beauty of Rwanda like never before.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),

            _SearchBar(
              onChanged: (v) => setState(() => searchQuery = v),
              onClear: () => setState(() => searchQuery = ""),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    selected: index == selectedCategoryIndex,
                    onTap: () => setState(() => selectedCategoryIndex = index),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top picks",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllDestinationsScreen()),
                    );
                  },
                  child: const Text("See all"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (filteredDestinations.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                ),
                child: Text(
                  "No places match your search.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;

                  final crossAxisCount = w >= 900
                      ? 4
                      : w >= 650
                      ? 3
                      : 2;

                  final aspectRatio = crossAxisCount == 2 ? 0.72 : 0.82;

                  return GridView.builder(
                    itemCount: filteredDestinations.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final d = filteredDestinations[index];
                      return DestinationCard(
                        destination: d,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(destination: d),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search places in Rwanda...",
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                widget.onClear();
                setState(() {});
              },
              icon: const Icon(Icons.close_rounded),
              tooltip: "Clear",
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}