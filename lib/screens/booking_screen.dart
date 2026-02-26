import 'package:flutter/material.dart';
import '../data/booking_store.dart';
import '../data/user_session.dart';
import '../models/destination.dart';
import '../widgets/info_chip.dart';
import '../widgets/primary_button.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Destination destination;

  const BookingScreen({super.key, required this.destination});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int travelers = 1;
  String transport = "Tourist Car";
  String dateLabel = DateFormat('MMM dd, yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = widget.destination;

    double transportFee;
    if (transport == "Helicopter") {
      transportFee = 180.0;
    } else if (transport == "Coaster Bus") {
      transportFee = 60.0;
    } else {
      transportFee = 30.0;
    }

    final total = (d.price * travelers) + transportFee;
    final user = UserSession.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        d.image,
                        width: 86,
                        height: 86,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              InfoChip(
                                icon: Icons.calendar_month_rounded,
                                label: dateLabel,
                              ),
                              InfoChip(
                                icon: Icons.schedule_rounded,
                                label: "${d.days} days",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Traveler Details",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),

              _FieldCard(
                child: Row(
                  children: [
                    const Icon(Icons.people_alt_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Travelers",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (travelers > 1) travelers--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text(
                      "$travelers",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => travelers++),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _FieldCard(
                child: Row(
                  children: [
                    const Icon(Icons.directions_car_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Transport",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Flexible(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: transport,
                          isDense: true,
                          items: const [
                            DropdownMenuItem(
                              value: "Tourist Car",
                              child: Text("Tourist Car"),
                            ),
                            DropdownMenuItem(
                              value: "Coaster Bus",
                              child: Text("Coaster Bus"),
                            ),
                            DropdownMenuItem(
                              value: "Helicopter",
                              child: Text("Helicopter"),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => transport = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _FieldCard(
                child: Row(
                  children: [
                    const Icon(Icons.person_outline_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Booked By",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        user == null ? "Guest" : user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Payment Summary",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  children: [
                    _RowLine(label: "Trip price", value: "\$${d.price.toStringAsFixed(0)}"),
                    const SizedBox(height: 8),
                    _RowLine(label: "Travelers", value: "x $travelers"),
                    const SizedBox(height: 8),
                    _RowLine(label: "Transport fee", value: "\$${transportFee.toStringAsFixed(0)}"),
                    const Divider(height: 22),
                    _RowLine(
                      label: "Total",
                      value: "\$${total.toStringAsFixed(0)}",
                      bold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              PrimaryButton(
                text: "Confirm Booking",
                icon: Icons.check_circle_outline_rounded,
                onPressed: () async {
                  BookingStore.add(
                    Booking(
                      destination: d,
                      travelers: travelers,
                      transport: transport,
                      total: total,
                      dateLabel: dateLabel,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking saved!"),
                      duration: Duration(milliseconds: 900),
                    ),
                  );

                  await Future.delayed(const Duration(milliseconds: 900));
                  if (!mounted) return;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Success"),
                      content: Text(
                        "Your booking for ${d.name} has been confirmed.\n\n"
                            "Transport: $transport\n"
                            "Travelers: $travelers\n"
                            "Total: \$${total.toStringAsFixed(0)}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  final Widget child;

  const _FieldCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: child,
    );
  }
}

class _RowLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _RowLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: Colors.black.withOpacity(bold ? 0.85 : 0.65),
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
              color: Colors.black.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}