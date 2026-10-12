import 'models.dart';

class Api {
  Future<List<Coffee>> fetchCoffees() async => coffeeMenu;
}

const coffeeMenu = <Coffee>[
  Coffee(id: 'cappuccino', name: 'Cappuccino', category: 'Cappuccino', subtitle: 'A little cup of comfort', price: 149, rating: 4.8, image: 'assets/images/cappuccino.jpg', description: 'Rich espresso meets silky steamed milk and a generous cloud of foam. A balanced, cosy classic with a smooth finish.'),
  Coffee(id: 'espresso', name: 'Espresso', category: 'Espresso', subtitle: 'Small cup. Bold energy.', price: 99, rating: 4.7, image: 'assets/images/espresso.jpg', description: 'A concentrated shot of coffee with a golden crema and deep roasted notes. Short, intense, and beautifully simple.'),
  Coffee(id: 'latte', name: 'Caramel Latte', category: 'Latte', subtitle: 'Smooth with a sweet side', price: 179, rating: 4.9, image: 'assets/images/latte.jpg', description: 'Espresso and velvety milk with a warm caramel finish. Your slow-morning favourite, made just the way you like it.'),
  Coffee(id: 'mocha', name: 'Classic Mocha', category: 'Mocha', subtitle: 'Coffee, meet chocolate', price: 189, rating: 4.8, image: 'assets/images/mocha.jpg', description: 'A comforting blend of espresso, chocolate, and steamed milk. Rich enough for a treat, balanced enough for every day.'),
  Coffee(id: 'cold', name: 'Cold Brew', category: 'Cold brew', subtitle: 'Chilled. Mellow. Refreshing.', price: 169, rating: 4.6, image: 'assets/images/cold_brew.jpg', description: 'Slow-steeped coffee served cold for a mellow, refreshing drink. Choose no milk to enjoy its clean roasted flavour.'),
  Coffee(id: 'vanilla', name: 'Vanilla Latte', category: 'Latte', subtitle: 'A softer kind of pick-me-up', price: 179, rating: 4.7, image: 'assets/images/latte.jpg', description: 'Our smooth espresso paired with creamy milk and a touch of vanilla. A familiar favourite with a fragrant finish.'),
];
