# Experiment 1: Working with Widgets and Layouts

## Aim
Design and develop a Flutter application that displays a list of fruit items using `Row`, `Column`, `Container`, `Card`, and `ListView` widgets. Create reusable custom widgets to organize the user interface effectively.

---

## Key Widgets Used
- **`ListView.builder`**: Lazily constructs scrollable list of items.
- **`Card`**: Elevated surface container with rounded corners and shadows.
- **`Container`**: Flexible box model for padding, margins, colors, and borders.
- **`Row`**: Horizontal layout widget.
- **`Column`**: Vertical layout widget.
- **Custom Reusable Widget**: `FruitCard` encapsulates the display logic of individual fruit items.

---

## Minimal Exam Bone Code (Memorize for Exam)

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FruitListScreen(),
    );
  }
}

// 1. Data Model
class Fruit {
  final String name;
  final String price;
  final IconData icon;

  const Fruit(this.name, this.price, this.icon);
}

// 2. Main Screen with ListView
class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  final List<Fruit> fruits = const [
    Fruit('Apple', '\$2.50', Icons.apple),
    Fruit('Banana', '\$1.20', Icons.eco),
    Fruit('Orange', '\$3.00', Icons.circle),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruit Market')),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          // Using reusable custom widget
          return FruitCard(fruit: fruits[index]);
        },
      ),
    );
  }
}

// 3. Reusable Custom Widget (Card + Container + Row + Column)
class FruitCard extends StatelessWidget {
  final Fruit fruit;
  const FruitCard({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(fruit.icon, color: Colors.green, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fruit.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('Fresh & Organic', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(fruit.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
```

---

## How to Run
```bash
cd exp1
flutter run
```
