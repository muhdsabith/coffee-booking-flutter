import 'package:flutter/material.dart';
import '../models.dart';

const amber = Color(0xFFFFA52E);
const background = Color(0xFF0D0F12);
const panel = Color(0xFF1B1E23);
const muted = Color(0xFFACAFB5);

class CoffeePhoto extends StatelessWidget {
  const CoffeePhoto(this.coffee, {super.key, this.fit = BoxFit.cover});
  final Coffee coffee;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(coffee.image, fit: fit, width: double.infinity, height: double.infinity, semanticLabel: coffee.name, errorBuilder: (_, error, stack) => Container(color: const Color(0xFF33271E), child: const Center(child: Icon(Icons.coffee_rounded, size: 64, color: amber))));
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8)), const SizedBox(height: 8), Text(subtitle, style: const TextStyle(color: muted, height: 1.5))]));
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action});
  final IconData icon;
  final String title, message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: panel, shape: BoxShape.circle), child: Icon(icon, size: 40, color: amber)), const SizedBox(height: 24), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)), if (action != null) ...[const SizedBox(height: 24), action!]])));
}

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child, this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(padding: padding, decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.05))), child: child);
}

class QuantityPicker extends StatelessWidget {
  const QuantityPicker({super.key, required this.value, required this.onChanged, this.allowRemove = false});
  final int value;
  final ValueChanged<int> onChanged;
  final bool allowRemove;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: value == 1 && allowRemove ? 'Remove item' : 'Decrease quantity', onPressed: value > 1 || allowRemove ? () => onChanged(value - 1) : null, icon: Icon(value == 1 && allowRemove ? Icons.delete_outline : Icons.remove, size: 20)), Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)), IconButton(tooltip: 'Increase quantity', onPressed: value < 20 ? () => onChanged(value + 1) : null, icon: const Icon(Icons.add, size: 20, color: amber))]);
}

String dateLabel(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day} ${months[date.month - 1]}';
}
String timeLabel(DateTime date) => '${date.hour % 12 == 0 ? 12 : date.hour % 12}:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
