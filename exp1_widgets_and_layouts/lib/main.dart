import 'package:flutter/material.dart';

void main() {
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 1: Fruit Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const FruitListScreen(),
    );
  }
}

class FruitItem {
  final String name;
  final String category;
  final double price;
  final String emoji;

  const FruitItem({
    required this.name,
    required this.category,
    required this.price,
    required this.emoji,
  });
}

class FruitListScreen extends StatefulWidget {
  const FruitListScreen({super.key});

  @override
  State<FruitListScreen> createState() => _FruitListScreenState();
}

class _FruitListScreenState extends State<FruitListScreen> {
  final List<FruitItem> fruits = const [
    FruitItem(name: 'Honeycrisp Apple', category: 'Pome', price: 2.99, emoji: '🍎'),
    FruitItem(name: 'Cavendish Banana', category: 'Tropical', price: 1.29, emoji: '🍌'),
    FruitItem(name: 'Valencia Orange', category: 'Citrus', price: 3.49, emoji: '🍊'),
    FruitItem(name: 'Alphonso Mango', category: 'Tropical', price: 5.99, emoji: '🥭'),
    FruitItem(name: 'Organic Strawberry', category: 'Berry', price: 4.50, emoji: '🍓'),
    FruitItem(name: 'Wild Blueberry', category: 'Berry', price: 4.99, emoji: '🫐'),
    FruitItem(name: 'Golden Pineapple', category: 'Tropical', price: 3.99, emoji: '🍍'),
    FruitItem(name: 'Crimson Watermelon', category: 'Melon', price: 6.49, emoji: '🍉'),
  ];

  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Fruit Market'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Cart: $_cartCount',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Basic Container demonstrating Container, Row, and Column
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade100,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fruit Market Catalog',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Demonstrating Row, Column, Container, Card & ListView'),
              ],
            ),
          ),
          // ListView displaying custom FruitCard widgets
          Expanded(
            child: ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return FruitCard(
                  fruit: fruit,
                  onAddToCart: () {
                    setState(() {
                      _cartCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${fruit.name} to cart')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Custom Widget demonstrating Card, Row, Column, and Container
class FruitCard extends StatelessWidget {
  final FruitItem fruit;
  final VoidCallback onAddToCart;

  const FruitCard({
    super.key,
    required this.fruit,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                fruit.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fruit.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Category: ${fruit.category}'),
                  Text(
                    '\$${fruit.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onAddToCart,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
