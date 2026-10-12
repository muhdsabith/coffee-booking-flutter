import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../widgets/common.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.coffee, required this.store, required this.openCart});
  final Coffee coffee;
  final CoffeeStore store;
  final VoidCallback openCart;
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String size = 'M', milk = 'Regular', sugar = 'No sugar';
  int quantity = 1;
  @override
  void initState() {
    super.initState();
    if (widget.coffee.id == 'espresso' || widget.coffee.id == 'cold') milk = 'No milk';
  }
  CartItem get item => CartItem(coffeeId: widget.coffee.id, size: size, milk: milk, sugar: sugar, quantity: quantity);
  Widget choices(String title, List<String> values, String value, ValueChanged<String> onChanged, {String? help}) => Padding(padding: const EdgeInsets.only(bottom: 22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)), if (help != null) ...[const SizedBox(height: 6), Text(help, style: const TextStyle(color: muted, fontSize: 12))], const SizedBox(height: 10), Wrap(spacing: 10, runSpacing: 8, children: values.map((option) => ChoiceChip(label: Text(option), selected: value == option, onSelected: (_) => onChanged(option), showCheckmark: false, selectedColor: amber.withValues(alpha: 0.14), side: BorderSide(color: value == option ? amber : Colors.transparent), labelStyle: TextStyle(color: value == option ? amber : muted), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8))).toList())]));
  @override
  Widget build(BuildContext context) {
    final coffee = widget.coffee;
    final image = ClipRRect(borderRadius: BorderRadius.circular(28), child: AspectRatio(aspectRatio: 0.95, child: Stack(fit: StackFit.expand, children: [CoffeePhoto(coffee), const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xEF0D0F12)]))), Positioned(left: 22, right: 22, bottom: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(coffee.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8)), const SizedBox(height: 7), Text(coffee.subtitle, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 14), Row(children: [const Icon(Icons.star_rounded, color: amber, size: 20), const SizedBox(width: 5), Text('${coffee.rating}', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(width: 14), const Text('Medium roast', style: TextStyle(color: Colors.white70, fontSize: 12))])]))])));
    final options = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Your coffee, your way.', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)), const SizedBox(height: 12), Text(coffee.description, style: const TextStyle(color: muted, height: 1.7)), const SizedBox(height: 26), choices('Choose your size', sizes, size, (v) => setState(() => size = v), help: 'Small · base price   /   Medium +₹30   /   Large +₹60'), choices('Make it milky', milks, milk, (v) => setState(() => milk = v), help: 'Oat milk +₹40'), choices('Sweetness', sugars, sugar, (v) => setState(() => sugar = v)), Row(children: [const Expanded(child: Text('How many cups?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))), QuantityPicker(value: quantity, onChanged: (v) => setState(() => quantity = v))]), const SizedBox(height: 14), const Text('Prepared for pickup · Customised by you', style: TextStyle(color: muted, fontSize: 12))]);
    return Scaffold(
      appBar: AppBar(title: const Text('Make it yours', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)), actions: [AnimatedBuilder(animation: widget.store, builder: (context, _) => IconButton(tooltip: 'Toggle favourite', onPressed: () => widget.store.toggleFavourite(coffee.id), icon: Icon(widget.store.favourites.contains(coffee.id) ? Icons.favorite : Icons.favorite_border, color: amber))), const SizedBox(width: 12)]),
      body: SingleChildScrollView(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: Padding(padding: const EdgeInsets.all(24), child: LayoutBuilder(builder: (context, constraints) => constraints.maxWidth >= 700 ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: image), const SizedBox(width: 36), Expanded(child: options)]) : Column(children: [image, const SizedBox(height: 26), options])))))),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 20), child: Row(children: [Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Your total', style: TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 4), Text(money(item.unitPrice(coffee) * quantity), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800))])), const SizedBox(width: 16), Flexible(flex: 2, child: FilledButton.icon(onPressed: () {
        final messenger = ScaffoldMessenger.of(context);
        widget.store.add(item);
        Navigator.pop(context);
        messenger.showSnackBar(SnackBar(content: Text('${coffee.name} added to your bag'), action: SnackBarAction(label: 'View bag', onPressed: widget.openCart)));
      }, icon: const Icon(Icons.shopping_bag_outlined), label: const Text('Add to bag')))]))),
    );
  }
}
