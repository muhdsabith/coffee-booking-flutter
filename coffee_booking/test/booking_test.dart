import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_booking/models.dart';
import 'package:coffee_booking/store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CoffeeStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = CoffeeStore(await SharedPreferences.getInstance());
    await store.load();
  });

  test('customisation price and variant quantities stay separate', () {
    store.add(const CartItem(coffeeId: 'cappuccino', size: 'L', milk: 'Oat', quantity: 2));
    store.add(const CartItem(coffeeId: 'cappuccino', size: 'L', milk: 'Oat'));
    store.add(const CartItem(coffeeId: 'cappuccino', size: 'S'));
    expect(store.cart.length, 2);
    expect(store.count, 4);
    expect(store.total, (149 + 60 + 40) * 3 + 149);
    store.setQuantity(store.cart.first.key, 0);
    expect(store.total, 149);
  });

  test('pickup slots respect lead time and opening hours', () {
    final day = DateTime(2026, 10, 1);
    expect(pickupSlots(day, DateTime(2026, 10, 1, 8)).first, DateTime(2026, 10, 1, 9));
    expect(pickupSlots(day, DateTime(2026, 10, 1, 10, 20)).first, DateTime(2026, 10, 1, 11));
    expect(pickupSlots(day, DateTime(2026, 10, 1, 20, 11)), isEmpty);
    expect(pickupSlots(day, DateTime(2026, 10, 1, 8)).last, DateTime(2026, 10, 1, 20, 30));
  });

  test('booking snapshots survive restart and can be cancelled', () async {
    store.add(const CartItem(coffeeId: 'latte'));
    store.toggleFavourite('latte');
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 10);
    final booking = await store.book(name: 'Sabith', phone: '9876543210', notes: 'Extra warm', pickup: tomorrow);
    expect(store.cart, isEmpty);
    expect(booking.total, 209);
    final restored = CoffeeStore(await SharedPreferences.getInstance());
    await restored.load();
    expect(restored.bookings.single.id, booking.id);
    expect(restored.bookings.single.notes, 'Extra warm');
    expect(restored.favourites, contains('latte'));
    await restored.cancel(booking.id);
    final afterCancel = CoffeeStore(await SharedPreferences.getInstance());
    await afterCancel.load();
    expect(afterCancel.bookings.single.cancelled, isTrue);
  });

  test('invalid pickup cannot clear the cart', () async {
    store.add(const CartItem(coffeeId: 'espresso'));
    await expectLater(store.book(name: 'Test', phone: '9876543210', notes: '', pickup: DateTime.now()), throwsStateError);
    expect(store.cart, hasLength(1));
    expect(store.bookings, isEmpty);
  });

  test('corrupt saved data does not prevent menu access', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('coffee_state_v1', 'invalid json');
    final restored = CoffeeStore(prefs);
    await restored.load();
    expect(restored.coffees, isNotEmpty);
    expect(restored.storageWarning, isNotNull);
  });
}
