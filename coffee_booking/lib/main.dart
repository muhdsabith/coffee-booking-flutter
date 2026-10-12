import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store.dart';
import 'responsive.dart';
import 'screens/menu.dart';
import 'screens/cart.dart';
import 'screens/orders.dart';
import 'widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final store = CoffeeStore(await SharedPreferences.getInstance());
    await store.load();
    runApp(CoffeeApp(store: store));
  } catch (_) {
    runApp(MaterialApp(theme: ThemeData.dark(), home: const Scaffold(body: Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Coffee could not start. Please reopen the app and allow local storage.', textAlign: TextAlign.center))))));
  }
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key, required this.store});
  final CoffeeStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Brew & Go',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: amber, brightness: Brightness.dark, primary: amber, onPrimary: background, surface: panel),
      appBarTheme: const AppBarTheme(backgroundColor: background, surfaceTintColor: Colors.transparent, centerTitle: false),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: panel, contentPadding: const EdgeInsets.all(18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: amber))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: amber, foregroundColor: background, minimumSize: const Size(48, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: background, indicatorColor: amber.withValues(alpha: 0.16)),
    ),
    home: CoffeeShell(store: store),
  );
}

class CoffeeShell extends StatefulWidget {
  const CoffeeShell({super.key, required this.store});
  final CoffeeStore store;
  @override
  State<CoffeeShell> createState() => _CoffeeShellState();
}

class _CoffeeShellState extends State<CoffeeShell> {
  int selected = 0;
  void go(int value) => setState(() => selected = value);
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.store, builder: (context, _) {
    final wide = !Responsive.isMobile(context);
    final pages = [MenuScreen(store: widget.store, openCart: () => go(2)), MenuScreen(store: widget.store, favouritesOnly: true, openCart: () => go(2)), CartScreen(store: widget.store, browse: () => go(0), onBooked: () => go(3)), OrdersScreen(store: widget.store, browse: () => go(0))];
    final icons = [Icons.home_rounded, Icons.favorite_border_rounded, Icons.shopping_bag_outlined, Icons.receipt_long_outlined];
    final labels = ['Home', 'Favourites', 'My bag', 'Bookings'];
    Widget navIcon(int i) => i == 2 && widget.store.count > 0 ? Badge(label: Text('${widget.store.count}'), child: Icon(icons[i])) : Icon(icons[i]);
    return Scaffold(
      body: SafeArea(child: Row(children: [
        if (wide) NavigationRail(selectedIndex: selected, onDestinationSelected: go, labelType: NavigationRailLabelType.all, backgroundColor: background, leading: const Padding(padding: EdgeInsets.symmetric(vertical: 26), child: Icon(Icons.coffee, color: amber, size: 32)), destinations: List.generate(4, (i) => NavigationRailDestination(icon: navIcon(i), label: Text(labels[i])))),
        if (wide) const VerticalDivider(width: 1, color: panel),
        Expanded(child: Column(children: [if (widget.store.storageWarning != null) MaterialBanner(content: Text(widget.store.storageWarning!), actions: [TextButton(onPressed: widget.store.save, child: const Text('Retry'))]), Expanded(child: Align(alignment: Alignment.topCenter, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1200), child: IndexedStack(index: selected, children: pages))))])),
      ])),
      bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: selected, onDestinationSelected: go, destinations: List.generate(4, (i) => NavigationDestination(icon: navIcon(i), label: labels[i]))),
    );
  });
}
