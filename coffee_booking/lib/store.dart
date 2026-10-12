import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apis.dart';
import 'models.dart';

class CoffeeStore extends ChangeNotifier {
  CoffeeStore(this.preferences);
  final SharedPreferences preferences;
  List<Coffee> coffees = [];
  List<CartItem> cart = [];
  Set<String> favourites = {};
  List<Booking> bookings = [];
  String? storageWarning;
  Future<void> _pending = Future<void>.value();
  Coffee coffee(String id) => coffees.firstWhere((item) => item.id == id);
  int get count => cart.fold(0, (sum, item) => sum + item.quantity);
  int get total => cart.fold(0, (sum, item) => sum + item.unitPrice(coffee(item.coffeeId)) * item.quantity);

  Future<void> load() async {
    coffees = await Api().fetchCoffees();
    try {
      final raw = preferences.getString('coffee_state_v1');
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final ids = coffees.map((e) => e.id).toSet();
        final loadedCart = (data['cart'] as List).map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map))).where((e) => ids.contains(e.coffeeId) && sizes.contains(e.size) && milks.contains(e.milk) && sugars.contains(e.sugar) && e.quantity > 0 && e.quantity <= 20).toList();
        final loadedBookings = (data['bookings'] as List).map((e) => Booking.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        final loadedFavourites = (data['favourites'] as List).cast<String>().where(ids.contains).toSet();
        cart = loadedCart;
        bookings = loadedBookings;
        favourites = loadedFavourites;
      }
    } catch (_) {
      storageWarning = 'Saved data could not be loaded. You can still browse the menu.';
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final snapshot = jsonEncode({'cart': cart.map((e) => e.toJson()).toList(), 'favourites': favourites.toList(), 'bookings': bookings.map((e) => e.toJson()).toList()});
    final write = _pending.then((_) async {
      if (!await preferences.setString('coffee_state_v1', snapshot)) throw StateError('Could not save on this device.');
    });
    _pending = write.catchError((Object error) {});
    await write;
  }

  Future<void> save() async {
    try {
      await _persist();
      storageWarning = null;
    } catch (_) {
      storageWarning = 'Changes could not be saved. Check your device storage and try again.';
    }
    notifyListeners();
  }

  void toggleFavourite(String id) {
    if (!favourites.add(id)) favourites.remove(id);
    notifyListeners();
    save();
  }

  void add(CartItem item) {
    final index = cart.indexWhere((e) => e.key == item.key);
    if (index < 0) {
      cart.add(item);
    } else {
      cart[index] = cart[index].withQuantity((cart[index].quantity + item.quantity).clamp(1, 20).toInt());
    }
    notifyListeners();
    save();
  }

  void setQuantity(String key, int quantity) {
    final index = cart.indexWhere((e) => e.key == key);
    if (index < 0) return;
    if (quantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index] = cart[index].withQuantity(quantity.clamp(1, 20).toInt());
    }
    notifyListeners();
    save();
  }

  Future<Booking> book({required String name, required String phone, required String notes, required DateTime pickup}) async {
    if (cart.isEmpty) throw StateError('Add a coffee first.');
    if (!pickupSlots(pickup, DateTime.now()).contains(pickup)) throw StateError('Please choose a new pickup time.');
    final oldCart = List<CartItem>.of(cart);
    final booking = Booking(id: 'BR-${DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase()}', name: name.trim(), phone: phone.trim(), notes: notes.trim(), pickup: pickup, total: total, items: cart.map((e) => {...e.toJson(), 'name': coffee(e.coffeeId).name, 'unitPrice': e.unitPrice(coffee(e.coffeeId))}).toList());
    bookings.insert(0, booking);
    cart = [];
    try {
      await _persist();
    } catch (_) {
      bookings.removeWhere((e) => e.id == booking.id);
      cart = oldCart;
      rethrow;
    }
    notifyListeners();
    return booking;
  }

  Future<void> cancel(String id) async {
    final index = bookings.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final original = bookings[index];
    bookings[index] = original.cancel();
    try {
      await _persist();
    } catch (_) {
      bookings[index] = original;
      rethrow;
    }
    notifyListeners();
  }
}
