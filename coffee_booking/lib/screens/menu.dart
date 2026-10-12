import 'package:flutter/material.dart';
import '../store.dart';
import '../models.dart';
import '../responsive.dart';
import '../widgets/common.dart';
import 'details.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.store, required this.openCart, this.favouritesOnly = false});
  final CoffeeStore store;
  final VoidCallback openCart;
  final bool favouritesOnly;
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String query = '', category = 'All';
  final search = TextEditingController();
  @override
  void dispose() { search.dispose(); super.dispose(); }
  void details(Coffee coffee) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DetailsScreen(coffee: coffee, store: widget.store, openCart: widget.openCart)));
  @override
  Widget build(BuildContext context) {
    final matches = widget.store.coffees.where((c) => (!widget.favouritesOnly || widget.store.favourites.contains(c.id)) && (category == 'All' || c.category == category) && '${c.name} ${c.subtitle}'.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 32), children: [
      Row(children: [ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/images/brew_go_logo.png', width: 48, height: 48, semanticLabel: 'Brew & Go logo')), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('BREW & GO', style: TextStyle(fontSize: 13, letterSpacing: 2.3, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Your daily happy place', style: TextStyle(color: muted, fontSize: 12))])), IconButton(tooltip: 'About this app', onPressed: () => showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Welcome to Brew & Go'), content: const Text('Explore the sample menu and save a pickup booking on this device. This demo does not send orders to a café.\n\nSample pickup hours: 9 AM–9 PM. Last slot: 8:30 PM. Prices and ratings are sample data.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))])), icon: const Icon(Icons.info_outline, color: muted))]),
      const SizedBox(height: 30),
      PageHeading(widget.favouritesOnly ? 'Your favourites.' : 'Good days start\nwith great coffee.', widget.favouritesOnly ? 'The cups you keep coming back to.' : 'Find your flavour. Make it yours. Pick it up.'),
      if (!widget.favouritesOnly) ...[
        ClipRRect(borderRadius: BorderRadius.circular(24), child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 166), child: Stack(children: [Positioned.fill(child: CoffeePhoto(widget.store.coffee('latte'))), const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xEE1B140E), Color(0x331B140E)])))), Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('THE DAILY RITUAL', style: TextStyle(color: amber, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('A moment,\njust for you.', style: TextStyle(fontSize: 25, height: 1.1, fontWeight: FontWeight.w800)), const SizedBox(height: 8), InkWell(onTap: () => details(widget.store.coffee('latte')), child: const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Explore our latte  →', style: TextStyle(fontWeight: FontWeight.w700))))]))]))),
        const SizedBox(height: 26),
      ],
      TextField(controller: search, onChanged: (value) => setState(() => query = value), decoration: InputDecoration(hintText: 'Find your coffee...', prefixIcon: const Icon(Icons.search, color: muted), suffixIcon: query.isEmpty ? null : IconButton(tooltip: 'Clear search', onPressed: () { search.clear(); setState(() => query = ''); }, icon: const Icon(Icons.close)))),
      const SizedBox(height: 20),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['All', ...widget.store.coffees.map((c) => c.category).toSet()].map((value) => Padding(padding: const EdgeInsets.only(right: 10), child: ChoiceChip(label: Text(value), selected: category == value, onSelected: (_) => setState(() => category = value), showCheckmark: false, selectedColor: amber, labelStyle: TextStyle(color: category == value ? background : muted, fontWeight: FontWeight.w700), side: BorderSide.none))).toList())),
      const SizedBox(height: 24),
      Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 16, runSpacing: 8, children: [Text(widget.favouritesOnly ? 'Saved for you' : 'Made for your mood', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)), Text('${matches.length} coffees', style: const TextStyle(color: muted, fontSize: 12))]),
      const SizedBox(height: 16),
      if (matches.isEmpty) EmptyState(icon: widget.favouritesOnly ? Icons.favorite_border : Icons.search_off, title: widget.favouritesOnly && widget.store.favourites.isEmpty ? 'A favourite is waiting' : 'No coffees found', message: widget.favouritesOnly && widget.store.favourites.isEmpty ? 'Tap the heart on any coffee to save it here.' : 'Try a different name or category.'),
      LayoutBuilder(builder: (context, constraints) => GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: matches.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Responsive.columns(constraints.maxWidth), crossAxisSpacing: 16, mainAxisSpacing: 18, mainAxisExtent: 302 + (MediaQuery.textScalerOf(context).scale(16) - 16) * 4), itemBuilder: (context, index) {
        final coffee = matches[index];
        return CoffeeCard(coffee: coffee, favourite: widget.store.favourites.contains(coffee.id), onFavourite: () => widget.store.toggleFavourite(coffee.id), onOpen: () => details(coffee));
      })),
      const SizedBox(height: 28),
      const Text('Brewed with care. Enjoyed at your pace.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)),
    ]);
  }
}

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({super.key, required this.coffee, required this.favourite, required this.onFavourite, required this.onOpen});
  final Coffee coffee;
  final bool favourite;
  final VoidCallback onFavourite, onOpen;
  @override
  Widget build(BuildContext context) => Material(color: panel, borderRadius: BorderRadius.circular(24), clipBehavior: Clip.antiAlias, child: InkWell(onTap: onOpen, child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(17), child: Stack(fit: StackFit.expand, children: [CoffeePhoto(coffee), Positioned(left: 8, top: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.star_rounded, color: amber, size: 14), const SizedBox(width: 3), Text('${coffee.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]))), Positioned(right: 3, bottom: 3, child: IconButton.filled(tooltip: favourite ? 'Remove ${coffee.name} from favourites' : 'Save ${coffee.name}', onPressed: onFavourite, style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.65)), icon: Icon(favourite ? Icons.favorite : Icons.favorite_border, color: favourite ? amber : Colors.white, size: 20)))]))),
    const SizedBox(height: 12),
    Text(coffee.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    const SizedBox(height: 5),
    Text(coffee.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: muted)),
    const SizedBox(height: 5),
    Row(children: [Expanded(child: Text(money(coffee.price), style: const TextStyle(color: amber, fontSize: 16, fontWeight: FontWeight.w800))), IconButton.filled(tooltip: 'Customise ${coffee.name}', onPressed: onOpen, style: IconButton.styleFrom(backgroundColor: amber, foregroundColor: background), icon: const Icon(Icons.add, size: 20))]),
  ]))));
}
