class Coffee {
  final String id, name, category, subtitle, description, image;
  final int price;
  final double rating;
  const Coffee({required this.id, required this.name, required this.category, required this.subtitle, required this.description, required this.image, required this.price, required this.rating});
}

const sizes = ['S', 'M', 'L'];
const milks = ['Regular', 'Oat', 'No milk'];
const sugars = ['No sugar', 'Less sugar', 'Regular sugar'];

String money(int amount) => '₹$amount';

class CartItem {
  final String coffeeId, size, milk, sugar;
  final int quantity;
  const CartItem({required this.coffeeId, this.size = 'M', this.milk = 'Regular', this.sugar = 'No sugar', this.quantity = 1});
  String get key => '$coffeeId|$size|$milk|$sugar';
  int unitPrice(Coffee coffee) => coffee.price + (size == 'M' ? 30 : size == 'L' ? 60 : 0) + (milk == 'Oat' ? 40 : 0);
  CartItem withQuantity(int value) => CartItem(coffeeId: coffeeId, size: size, milk: milk, sugar: sugar, quantity: value);
  Map<String, dynamic> toJson() => {'coffeeId': coffeeId, 'size': size, 'milk': milk, 'sugar': sugar, 'quantity': quantity};
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(coffeeId: json['coffeeId'] as String, size: json['size'] as String, milk: json['milk'] as String, sugar: json['sugar'] as String, quantity: json['quantity'] as int);
}

class Booking {
  final String id, name, phone, notes;
  final DateTime pickup;
  final List<Map<String, dynamic>> items;
  final int total;
  final bool cancelled;
  const Booking({required this.id, required this.name, required this.phone, required this.notes, required this.pickup, required this.items, required this.total, this.cancelled = false});
  Booking cancel() => Booking(id: id, name: name, phone: phone, notes: notes, pickup: pickup, items: items, total: total, cancelled: true);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone, 'notes': notes, 'pickup': pickup.toIso8601String(), 'items': items, 'total': total, 'cancelled': cancelled};
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(id: json['id'] as String, name: json['name'] as String, phone: json['phone'] as String, notes: json['notes'] as String, pickup: DateTime.parse(json['pickup'] as String), items: (json['items'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList(), total: json['total'] as int, cancelled: json['cancelled'] as bool);
}

List<DateTime> pickupSlots(DateTime day, DateTime now) {
  final slots = <DateTime>[];
  for (var hour = 9; hour < 21; hour++) {
    for (final minute in [0, 30]) {
      final slot = DateTime(day.year, day.month, day.day, hour, minute);
      if (!slot.isBefore(now.add(const Duration(minutes: 20)))) slots.add(slot);
    }
  }
  return slots;
}
