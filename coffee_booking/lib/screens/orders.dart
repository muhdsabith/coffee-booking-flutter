import 'package:flutter/material.dart';
import '../store.dart';
import '../models.dart';
import '../widgets/common.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.store, required this.browse});
  final CoffeeStore store;
  final VoidCallback browse;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    const PageHeading('Your coffee plans.', 'All your saved pickups, in one place.'),
    if (store.bookings.isEmpty) EmptyState(icon: Icons.receipt_long_outlined, title: 'Your next cup is waiting', message: 'Saved pickup bookings will appear here.', action: FilledButton(onPressed: browse, child: const Text('Find your coffee'))),
    ...store.bookings.map((booking) => Padding(padding: const EdgeInsets.only(bottom: 18), child: Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 12, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [const Icon(Icons.coffee_rounded, color: amber), Text(booking.cancelled ? 'Cancelled' : 'Saved on this device', style: TextStyle(color: booking.cancelled ? muted : amber, fontWeight: FontWeight.w700))]),
      const SizedBox(height: 16),
      Text('${dateLabel(booking.pickup)} · ${timeLabel(booking.pickup)}', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('${booking.id}\nFor ${booking.name}', style: const TextStyle(color: muted, fontSize: 12, height: 1.7)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
      ...booking.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${item['quantity']} × ${item['name']}', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text('${item['size']} · ${item['milk']} · ${item['sugar']}', style: const TextStyle(color: muted, fontSize: 12))])), const SizedBox(width: 12), Text(money((item['unitPrice'] as int) * (item['quantity'] as int)))]))),
      if (booking.notes.isNotEmpty) ...[const SizedBox(height: 4), Text('Your note: ${booking.notes}', style: const TextStyle(color: muted, height: 1.5)), const SizedBox(height: 12)],
      Row(children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text(money(booking.total), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: amber))]),
      const SizedBox(height: 12),
      const Text('Demo booking · Not sent to a café', style: TextStyle(fontSize: 12, color: muted)),
      if (!booking.cancelled) ...[const SizedBox(height: 10), TextButton(onPressed: () async {
        final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Cancel this saved booking?'), content: const Text('This only updates the booking on this device.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep booking')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cancel booking'))]));
        if (confirmed != true) return;
        try {
          await store.cancel(booking.id);
        } catch (_) {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save the cancellation. Please try again.')));
        }
      }, child: const Text('Cancel saved booking'))],
    ])))),
  ]);
}
