import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafetería App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: const CoffeeListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Coffee {
  final String name;
  final String description;
  final String imageUrl;

  Coffee({required this.name, required this.description, required this.imageUrl});
}

class CoffeeListPage extends StatefulWidget {
  const CoffeeListPage({super.key});

  @override
  State<CoffeeListPage> createState() => _CoffeeListPageState();
}

class _CoffeeListPageState extends State<CoffeeListPage> {
  final List<Coffee> coffees = [
    Coffee(
      name: 'Café Espresso',
      description: 'Un café fuerte y concentrado.',
      imageUrl: 'https://images.unsplash.com/photo-1511920170042-ecf8b9c2e5f0',
    ),
    Coffee(
      name: 'Café Latte',
      description: 'Café con leche espumosa.',
      imageUrl: 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    ),
    Coffee(
      name: 'Café Americano',
      description: 'Café diluido con agua caliente.',
      imageUrl: 'https://images.unsplash.com/photo-1521747116042-5a810fda9664',
    ),
    Coffee(
      name: 'Café Mocha',
      description: 'Café con chocolate y leche.',
      imageUrl: 'https://images.unsplash.com/photo-1540071949654-1f8f3c4e6c5f',
    ),
    Coffee(
      name: 'Café Capuchino',
      description: 'Café con espuma de leche.',
      imageUrl: 'https://images.unsplash.com/photo-1565299624943-7a69b1c1e7b8',
    ),
    Coffee(
      name: 'Café Frappé',
      description: 'Café helado y cremoso.',
      imageUrl: 'https://images.unsplash.com/photo-1550525939-0e2f0a4c3e2b',
    ),
    Coffee(
      name: 'Café Cortado',
      description: 'Café con un toque de leche.',
      imageUrl: 'https://images.unsplash.com/photo-1601440641076-8c2e7f8d3e9b',
    ),
    Coffee(
      name: 'Café con Leche',
      description: 'Café con leche caliente.',
      imageUrl: 'https://images.unsplash.com/photo-1589927986089-1e1f9e04b1d9',
    ),
  ];

  final List<Coffee> cart = [];
  final List<Coffee> favorites = [];

  void _addToCart(Coffee coffee) {
    setState(() {
      cart.add(coffee);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${coffee.name} agregado al carrito')),
    );
  }

  void _toggleFavorite(Coffee coffee) {
    setState(() {
      if (favorites.contains(coffee)) {
        favorites.remove(coffee);
      } else {
        favorites.add(coffee);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(favorites.contains(coffee) ? '${coffee.name} agregado a favoritos' : '${coffee.name} eliminado de favoritos')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafetería'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        maxWidth: 20,
                        maxHeight: 20,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favorites: favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: coffees.length,
        itemBuilder: (context, index) {
          final coffee = coffees[index];
          return Card(
            color: Colors.brown[800],
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(coffee.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    coffee.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  coffee.description,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addToCart(coffee),
                      child: const Text('Agregar'),
                    ),
                    IconButton(
                      icon: Icon(
                        favorites.contains(coffee) ? Icons.favorite : Icons.favorite_border,
                        color: favorites.contains(coffee) ? Colors.red : Colors.white,
                      ),
                      onPressed: () => _toggleFavorite(coffee),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Coffee> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('El carrito está vacío', style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final coffee = cart[index];
                return ListTile(
                  title: Text(coffee.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(coffee.description, style: const TextStyle(color: Colors.white70)),
                );
              },
            ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Coffee> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No tienes favoritos', style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final coffee = favorites[index];
                return ListTile(
                  title: Text(coffee.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(coffee.description, style: const TextStyle(color: Colors.white70)),
                );
              },
            ),
    );
  }
}
