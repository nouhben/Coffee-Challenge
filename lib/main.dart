import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gorcy/coffee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainCoffeeConceptApp(),
    );
  }
}

const _backgroundColor = Color(0XFFF6F5F2);
const _appBarHeight = 48.0;
const _cartBarHeight = 148.0;
const _panelTransitionDuration = Duration(milliseconds: 400);

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeViewModel = HomeScreenViewModel();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GroceryStoreProvider(
      viewModel: homeViewModel,
      child: AnimatedBuilder(
        animation: homeViewModel,
        // Because animatedBuilder needs a change notifier
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0.0,
              leading: const BackButton(color: Colors.black),
              backgroundColor: _backgroundColor,
              toolbarHeight: _appBarHeight,
            ),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: _panelTransitionDuration,
                          curve: Curves.decelerate,

                          left: 0.0,
                          right: 0.0,
                          top: _getWhitePanelTop(
                            size,
                            homeViewModel.state,
                          ), //-_cartBarHeight,
                          height: size.height - _appBarHeight,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(36.0),
                              bottomLeft: Radius.circular(36.0),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: const StoreCatalog(),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: _panelTransitionDuration,
                          curve: Curves.decelerate,
                          left: 0.0,
                          right: 0.0,
                          top: _getBlackPanelTop(
                            size,
                            homeViewModel.state,
                          ), //size.height - _appBarHeight - _cartBarHeight,
                          height: size.height,
                          child: GestureDetector(
                            onVerticalDragUpdate: _onVerticalDrag,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onVerticalDrag(DragUpdateDetails details) async {
    if (details.primaryDelta! < -7) {
      homeViewModel.changeToCart();
    } else if (details.primaryDelta! > 12) {
      homeViewModel.changeToNormal();
    }
  }

  double _getWhitePanelTop(Size size, GroceriesState state) {
    if (state == GroceriesState.normal) {
      return -_cartBarHeight;
    } else {
      if (state == GroceriesState.cart) {
        return -(size.height - _appBarHeight - _cartBarHeight / 2);
      }
    }
    return 0.0;
  }

  double _getBlackPanelTop(Size size, GroceriesState state) {
    if (state == GroceriesState.normal) {
      return size.height - _appBarHeight - _cartBarHeight;
    } else {
      if (state == GroceriesState.cart) {
        return (_cartBarHeight / 2);
      }
    }
    return 0.0;
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appBarHeight,
      color: _backgroundColor,
      child: Row(
        children: [
          const BackButton(color: Colors.black),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              'Fruits & Veggies',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}

class HomeScreenViewModel with ChangeNotifier {
  GroceriesState _groceriesState = GroceriesState.normal;
  List<Product> catalog = _mockProducts;

  GroceriesState get state => _groceriesState;
  void changeToNormal() {
    _groceriesState = GroceriesState.normal;
    notifyListeners();
  }

  void changeToDetails() {
    _groceriesState = GroceriesState.details;
    notifyListeners();
  }

  void changeToCart() {
    _groceriesState = GroceriesState.cart;
    notifyListeners();
  }
}

enum GroceriesState { normal, details, cart }

class Product {
  final String name;
  final int price;
  final String description;
  final String image;
  final int weight;
  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.weight,
  });
}

final _mockProducts = <Product>[
  Product(
    name: 'Anannas',
    price: 19,
    description: 'description',
    image: 'assets/images/ananas.jpeg',
    weight: 500,
  ),
  Product(
    name: 'Bananas',
    price: 19,
    description: 'description',
    image: 'assets/images/banane.jpeg',
    weight: 500,
  ),
  Product(
    name: 'Avocat',
    price: 34,
    description: 'description',
    image: 'assets/images/avocat.jpeg',
    weight: 200,
  ),
  Product(
    name: 'Exotic',
    price: 340,
    description: 'description',
    image: 'assets/images/exotic.jpeg',
    weight: 100,
  ),
  Product(
    name: 'Dragon Fruit',
    price: 34,
    description: 'description Dragon Fruit',
    image: 'assets/images/dragon.jpeg',
    weight: 300,
  ),
  Product(
    name: 'Grapes',
    price: 18,
    description: 'description',
    image: 'assets/images/grp.jpeg',
    weight: 500,
  ),
  Product(
    name: 'Mango',
    price: 180,
    description: 'description: Mango Fruit',
    image: 'assets/images/mng.jpeg',
    weight: 900,
  ),
  Product(
    name: 'Tropic',
    price: 68,
    description: 'description',
    image: 'assets/images/tropic.jpeg',
    weight: 700,
  ),
];

class GroceryStoreProvider extends InheritedWidget {
  final HomeScreenViewModel viewModel;
  const GroceryStoreProvider({
    required Widget child,
    required this.viewModel,
  }) : super(child: child);
  static GroceryStoreProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GroceryStoreProvider>()!;
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class StoreCatalog extends StatelessWidget {
  const StoreCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = GroceryStoreProvider.of(context).viewModel;
    return Container(
      color: _backgroundColor,
      padding: const EdgeInsets.only(top: _cartBarHeight),
      child: StaggredDualView(
        spacing: 20.0,
        aspectRatio: 0.7,
        offsetPercent: 0.3,
        itemCount: homeViewModel.catalog.length,
        itemBuilder: (context, index) {
          final p = homeViewModel.catalog[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FadeTransition(
                    opacity: animation,
                    child: StoreItemDetails(product: p),
                  ),
                ),
              );
            },
            child: Card(
              elevation: 8.0,
              shadowColor: Colors.black54,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: p.image,
                        child: Image.asset(
                          p.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$${p.price}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${p.weight}g',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StaggredDualView extends StatelessWidget {
  final double spacing;
  final double aspectRatio;
  final double offsetPercent;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  const StaggredDualView({
    Key? key,
    required this.spacing,
    this.aspectRatio = 0.5,
    this.offsetPercent = 0.5,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final _width = constraints.maxWidth;
      final _itemHeight = (_width * 0.5) / aspectRatio;
      final _height = constraints.maxHeight + _itemHeight;
      return OverflowBox(
        maxWidth: _width,
        minWidth: _width,
        maxHeight: _height,
        minHeight: _height,
        child: GridView.builder(
          padding: EdgeInsets.only(top: _itemHeight / 2, bottom: _itemHeight),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) => Transform.translate(
            offset: Offset(
              0.0,
              index.isOdd ? _itemHeight * offsetPercent : 0.0,
            ),
            child: itemBuilder(context, index),
          ),
          itemCount: itemCount,
        ),
      );
    });
  }
}

class StoreItemDetails extends StatelessWidget {
  const StoreItemDetails({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: const BackButton(color: Colors.black),
        backgroundColor: _backgroundColor,
        toolbarHeight: _appBarHeight,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Hero(
          tag: product.image,
          child: Image.asset(
            product.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MainCoffeeConceptApp extends StatelessWidget {
  const MainCoffeeConceptApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: const CoffeeConceptList(),
    );
  }
}

class CoffeeConceptList extends StatefulWidget {
  const CoffeeConceptList({Key? key}) : super(key: key);

  @override
  State<CoffeeConceptList> createState() => _CoffeeConceptListState();
}

class _CoffeeConceptListState extends State<CoffeeConceptList> {
  final PageController _pageCoffeeController = PageController(
    viewportFraction: 0.35,
  );
  final PageController _pageTextController = PageController();
  double _currentPage = 0.0;
  double _textPage = 0.0;
  @override
  void initState() {
    super.initState();
    _pageCoffeeController.addListener(_coffeeScrollListener);
    _pageTextController.addListener(_coffeePriceScrollListener);
  }

  void _coffeeScrollListener() {
    setState(() {
      _currentPage = _pageCoffeeController.page!;
    });
  }

  void _coffeePriceScrollListener() {
    setState(() => _textPage = _currentPage);
  }

  @override
  void dispose() {
    _pageCoffeeController.removeListener(_coffeeScrollListener);
    _pageTextController.removeListener(_coffeePriceScrollListener);
    _pageTextController.dispose();
    _pageCoffeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100.0,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: coffees.length,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageTextController,
                    itemBuilder: (context, index) {
                      final opacity =
                          (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width * .2),
                          child: Text(
                            coffees[index].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                AnimatedSwitcher(
                  key: Key(coffees[_currentPage.toInt()].name),
                  duration: _duration,
                  child: Text(
                    '\$${coffees[_currentPage.toInt()].price.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 22.0),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            height: size.height * .3,
            bottom: -size.height * .22,
            left: 20,
            right: 20,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 90,
                    spreadRadius: 45,
                  ),
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: 1.6,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
              itemCount: coffees.length + 1,
              scrollDirection: Axis.vertical,
              controller: _pageCoffeeController,
              onPageChanged: (value) {
                if (value < coffees.length) {
                  _pageTextController.animateToPage(
                    value,
                    duration: _duration,
                    curve: Curves.easeOut,
                  );
                }
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox.shrink();
                }
                final _coffee = coffees.elementAt(index - 1);
                final result = _currentPage - index + 1;
                final value = -0.4 * result + 1;
                final opacity = value.clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(
                        0.0,
                        size.height / 2.6 * (1 - value).abs(),
                      )
                      ..scale(value),
                    child: Opacity(
                      opacity: opacity,
                      child: Image.asset(
                        _coffee.image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _duration = Duration(milliseconds: 200);
