import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../widgets/common.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.store});
  final CoffeeStore store;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), phone = TextEditingController(), notes = TextEditingController();
  late DateTime day;
  DateTime? slot;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    day = DateTime(now.year, now.month, now.day);
    if (pickupSlots(day, now).isEmpty) day = DateTime(now.year, now.month, now.day + 1);
    slot = pickupSlots(day, now).first;
  }
  @override
  void dispose() { name.dispose(); phone.dispose(); notes.dispose(); super.dispose(); }
  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (slot == null || !pickupSlots(day, DateTime.now()).contains(slot)) {
      setState(() => slot = null);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose an available pickup time.')));
      return;
    }
    setState(() => saving = true);
    try {
      final booking = await widget.store.book(name: name.text, phone: phone.text, notes: notes.text, pickup: slot!);
      if (!mounted) return;
      await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => PopScope(canPop: false, child: AlertDialog(icon: const Icon(Icons.check_circle_rounded, color: amber, size: 54), title: const Text('Your coffee plan is saved!'), content: Text('${booking.id}\n${dateLabel(booking.pickup)} · ${timeLabel(booking.pickup)}\n\nThis demo booking is saved on your device. It has not been sent to a café.'), actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('View my bookings'))])));
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save your booking. Your bag is unchanged. Please try again.')));
    }
  }
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final slots = pickupSlots(day, now);
    final days = List.generate(7, (index) => DateTime(now.year, now.month, now.day + index));
    return PopScope(canPop: !saving, child: Scaffold(appBar: AppBar(title: const Text('Plan your pickup')), body: AbsorbPointer(absorbing: saving, child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 660), child: Form(key: form, child: ListView(padding: const EdgeInsets.all(24), children: [
      const PageHeading('Skip the wait.', 'Choose a time that fits your day.'),
      const Surface(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.coffee_rounded, color: amber), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Brew & Go · Demo café', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('Pickup only · 9 AM–9 PM\nBookings stay on this device.', style: TextStyle(color: muted, height: 1.6, fontSize: 13))]))])),
      const SizedBox(height: 28),
      const Text('Pick a day', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: days.map((value) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(value == days.first ? 'Today' : dateLabel(value)), selected: day == value, onSelected: (_) => setState(() { day = value; final next = pickupSlots(day, DateTime.now()); slot = next.isEmpty ? null : next.first; }), showCheckmark: false, selectedColor: amber, labelStyle: TextStyle(color: day == value ? background : Colors.white)))).toList())),
      const SizedBox(height: 24),
      const Text('Pickup time', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      if (slots.isEmpty) const Text('No slots left today. Please choose another day.', style: TextStyle(color: amber)) else DropdownButtonFormField<DateTime>(key: ValueKey('${day.toIso8601String()}-${slot?.toIso8601String()}'), initialValue: slots.contains(slot) ? slot : null, isExpanded: true, hint: const Text('Select a time'), items: slots.map((value) => DropdownMenuItem(value: value, child: Text(timeLabel(value)))).toList(), onChanged: (value) => setState(() => slot = value), validator: (value) => value == null ? 'Choose a pickup time' : null),
      const SizedBox(height: 10),
      const Text('Allow at least 20 minutes before pickup.', style: TextStyle(color: muted, fontSize: 12)),
      const SizedBox(height: 28),
      TextFormField(controller: name, textCapitalization: TextCapitalization.words, maxLength: 60, decoration: const InputDecoration(labelText: 'Your name', prefixIcon: Icon(Icons.person_outline)), validator: (value) => (value ?? '').trim().length < 2 ? 'Enter your name (at least 2 letters)' : null),
      const SizedBox(height: 12),
      TextFormField(controller: phone, keyboardType: TextInputType.phone, maxLength: 16, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '10-digit Indian mobile number', prefixIcon: Icon(Icons.phone_outlined)), validator: (value) => RegExp(r'^(?:\+91[ -]?)?[6-9]\d{9}$').hasMatch((value ?? '').trim()) ? null : 'Enter a valid Indian mobile number'),
      const SizedBox(height: 12),
      TextFormField(controller: notes, maxLength: 200, maxLines: 3, decoration: const InputDecoration(labelText: 'Any special requests?', hintText: 'Optional note for your coffee')),
      const SizedBox(height: 20),
      Surface(child: Column(children: [Row(children: [const Text('Booking total', style: TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text(money(widget.store.total), style: const TextStyle(fontSize: 25, color: amber, fontWeight: FontWeight.w800))]), const SizedBox(height: 12), const Text('No payment will be collected. This is a demo booking, not a confirmed café order.', style: TextStyle(color: muted, height: 1.5, fontSize: 12))])),
      const SizedBox(height: 24),
      FilledButton(onPressed: saving || slots.isEmpty ? null : submit, child: saving ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save pickup booking')),
      const SizedBox(height: 18),
    ])))))));
  }
}
