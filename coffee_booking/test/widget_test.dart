import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_booking/main.dart';
import 'package:coffee_booking/store.dart';

void main() {
  for (final width in [320.0, 390.0, 850.0, 1280.0]) {
    testWidgets('menu and cart work at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final store = CoffeeStore(await SharedPreferences.getInstance());
      await store.load();
      await tester.pumpWidget(CoffeeApp(store: store));
      await tester.pumpAndSettle();
      expect(find.text('BREW & GO'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextField).first, 'zzzz');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('No coffees found'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('No coffees found'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('My bag').last);
      await tester.pumpAndSettle();
      expect(find.text('Room for something good'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
