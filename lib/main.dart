import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends ChangeNotifier {
  List<Product> products = [];
  void add(Product product) {
    products.add(product);
    notifyListeners();
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Cart(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("eCommerce"),
                bottom: TabBar(isScrollable: true, tabs: [
                  Tab(
                    icon: Icon(Icons.store),
                    text: "Stores",
                  ),
                  Tab(
                    icon: Icon(Icons.smartphone),
                    text: "Products",
                  ),
                  Tab(
                    icon: Consumer<Cart>(
                      builder: (context, value, child) {
                        return Badge(
                            label: Text(value.products.length.toString()),
                            child: const Icon(
                              Icons.shopping_cart,
                            ));
                      },
                    ),
                    text: "My Cart",
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_long),
                    text: "My Orders",
                  ),
                ]),
              ),
              body: const TabBarView(
                children: [
                  AllStoresPage(),
                  Placeholder(),
                  CartPage(),
                  Placeholder()
                ],
              ),
            )));
  }
}

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});
  final Store store;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Image(image: AssetImage(store.imagePath), width: 100),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(store.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      "Type: ${store.type}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StorePage(
                                        store: store,
                                      )));
                        },
                        child: const Text("Visit Store"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllStoresPage extends StatelessWidget {
  const AllStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        StoreCard(
            store: Store(
                name: "American Eagle",
                type: "Clothing",
                imagePath: "assets/stores/american-eagle/logo.png",
                sections: [
              Section(name: "T-Shirts", products: [
                Product(
                    name: "AE Super Soft Legend Henley",
                    imagePath: "assets/stores/american-eagle/t-shirts/1.webp",
                    price: 463.50)
              ]),
              Section(name: "Pants", products: []),
              Section(name: "Shoes", products: [])
            ])),
        StoreCard(
            store: Store(
                name: "H&M",
                type: "Clothing",
                imagePath: "assets/stores/hm/logo.png",
                sections: [
              Section(name: "T-Shirts", products: []),
              Section(name: "Pants", products: []),
              Section(name: "Shoes", products: [])
            ]))
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 200,
          child: Row(
            children: [
              Image(
                image: AssetImage(product.imagePath),
                width: 140,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 15)),
                    Text(
                      "E£${product.price}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          cart.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item Added to Cart"),
                            ),
                          );
                        },
                        child: const Text("Add to Cart"))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class StorePage extends StatelessWidget {
  final Store store;
  const StorePage({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: store.sections.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(store.name),
            bottom: TabBar(
                tabs: store.sections
                    .map((e) => Tab(
                          text: e.name,
                        ))
                    .toList()),
          ),
          body: TabBarView(
            children: [
              StoreSectionPage(
                section: store.sections[0],
              ),
              const Placeholder(),
              const Placeholder()
            ],
          )),
    );
  }
}

class StoreSectionPage extends StatelessWidget {
  final Section section;
  const StoreSectionPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: section.products.map((e) => ProductCard(product: e)).toList(),
    );
  }
}

class Store {
  final String name;
  final String type;
  final String imagePath;
  final List<Section> sections;
  const Store(
      {required this.name,
      required this.type,
      required this.imagePath,
      required this.sections});
}

class Product {
  final String name;
  final double price;
  final String imagePath;

  Product({required this.name, required this.price, required this.imagePath});
}

class Section {
  final String name;
  final List<Product> products;

  Section({required this.name, required this.products});
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView(
          children: cart.products.map((e) => Text(e.name)).toList(),
        );
      },
    );
  }
}
