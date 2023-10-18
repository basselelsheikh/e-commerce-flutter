import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
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
                bottom: const TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.store),
                    text: "Stores",
                  ),
                  Tab(
                    icon: Icon(Icons.smartphone),
                    text: "Products",
                  ),
                  Tab(
                    icon: Icon(Icons.shopping_cart),
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
                  StoresHomePage(),
                  Placeholder(),
                  Placeholder(),
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StorePage(
                      store: store,
                    )));
      },
      child: Card(
        child: Container(
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
                  children: [
                    Text(store.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      "Type: ${store.type}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
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

class StoresHomePage extends StatelessWidget {
  const StoresHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        StoreCard(
            store: Store(
                name: "American Eagle",
                type: "Clothing",
                imagePath: "assets/stores-logos/ae.png")),
        StoreCard(
            store: Store(
                name: "H&M",
                type: "Clothing",
                imagePath: "assets/stores-logos/hm.png"))
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.price});
  final String imagePath;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(image: AssetImage(imagePath)),
        const SizedBox(
          height: 30,
        ),
        Text(name, style: Theme.of(context).textTheme.headlineSmall),
        Text("Price $price", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class StorePage extends StatelessWidget {
  final Store store;
  const StorePage({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Center(
          child: Image(
            image: AssetImage(store.imagePath),
            height: 100,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Expanded(
          child: ListView(
            children: const [
              Card(
                child: ListTile(
                  title: Text("T-Shirts"),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class Store {
  final String name;
  final String type;
  final String imagePath;
  const Store(
      {required this.name, required this.type, required this.imagePath});
}
