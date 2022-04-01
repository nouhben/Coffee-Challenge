import 'dart:math';

class Coffee {
  const Coffee({
    required this.name,
    required this.image,
    required this.price,
  });
  final String name;
  final String image;
  final double price;
}

double _doubleInRange(Random source, num start, num end) =>
    source.nextDouble() * (end - start) + 0.4;
Random _random = Random();
final coffees = List.generate(
  _names.length,
  (index) => Coffee(
    name: _names[index],
    image: 'assets/coffee_assets/${index + 1}.png',
    price: _doubleInRange(_random, 3, 7),
  ),
);

final _names = [
  'Caramel Cold Drink',
  'Iced Coffee Mocha',
  'Caramelized Pecan Latte',
  'Toffee Nut Latte',
  'Capuccino',
  'Toffee Nut Iced Latte',
  'Americano',
  'Caramel Macchiato',
  'Vietnamese-style Iced Coffee',
  'Black Tea Latte',
  'Classic Irish Coffee',
  'Toffee Nut Crunch Latte',
];
