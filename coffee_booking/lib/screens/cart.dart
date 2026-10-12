import 'package:flutter/material.dart';
import '../store.dart';
import '../models.dart';
import '../widgets/common.dart';
import 'checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.store, required this.browse, required this.onBooked});
  final CoffeeStore store;
  final VoidCallback browse, onBooked;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    const PageHeading('Your coffee bag.', 'A few good things, made just for you.'),
    if (store.cart.isEmpty) EmptyState(icon: Icons.shopping_bag_outlined, title: 'Room for something good', message: 'Choose a coffee and make it yours.', action: FilledButton(onPressed: browse, child: const Text('Explore the menu'))),
    ...store.cart.map((item) {
      final coffee = store.coffee(item.coffeeId);
      return Padding(padding: const EdgeInsets.only(bottom: 16), child: Surface(padding: const EdgeInsets.all(14), child: Column(children: [Row(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: BorderRadius.circular(16), child: SizedBox(width: 80, height: 90, child: CoffeePhoto(coffee))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(coffee.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), const SizedBox(height: 7), Text('${item.size} · ${item.milk}\n${item.sugar}', style: const TextStyle(color: muted, fontSize: 12, height: 1.6)), const SizedBox(height: 8), Text('${money(item.unitPrice(coffee))} / cup', style: const TextStyle(color: amber, fontWeight: FontWeight.w700))]))]), const SizedBox(height: 8), Row(children: [Text(money(item.unitPrice(coffee) * item.quantity), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const Spacer(), QuantityPicker(value: item.quantity, allowRemove: true, onChanged: (v) => store.setQuantity(item.key, v))])])));
    }),
    if (store.cart.isNotEmpty) ...[
      const SizedBox(height: 12),
      Surface(child: Column(children: [Row(children: [Text('${store.count} cup${store.count == 1 ? '' : 's'}', style: const TextStyle(color: muted)), const Spacer(), Text(money(store.total))]), const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()), Row(children: [const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const Spacer(), Text(money(store.total), style: const TextStyle(fontSize: 26, color: amber, fontWeight: FontWeight.w800))]), const SizedBox(height: 12), const Text('Sample prices · No payment required', style: TextStyle(color: muted, fontSize: 12))])),
      const SizedBox(height: 22),
      FilledButton.icon(onPressed: () async {
        final completed = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => CheckoutScreen(store: store)));
        if (completed == true) onBooked();
      }, icon: const Icon(Icons.schedule_rounded), label: const Text('Choose pickup time')),
      const SizedBox(height: 14),
      TextButton(onPressed: browse, child: const Text('Add another coffee')),
    ],
  ]);
}
