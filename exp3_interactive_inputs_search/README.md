# Experiment 3: Add Interactivity to App – Input and Forms

## Aim
Develop a Flutter application that displays a predefined list of products and allows users to search or filter the products using input widgets, providing an interactive user experience.

---

## Key Interactivity & Input Concepts Used
- **`StatefulWidget` & `setState`**: Manages dynamic filtering state based on user inputs.
- **`TextField`**: Captures real-time text input via `onChanged` to filter the product list dynamically.
- **`TextEditingController`**: Manages search query lifecycle and clears search text.
- **List Filtering**: Uses Dart's `.where()` with `contains()` for case-insensitive matching.
- **Interactive Feedback**: Dynamic search result count and empty state message when no items match.

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
      home: InteractiveSearchScreen(),
    );
  }
}

class InteractiveSearchScreen extends StatefulWidget {
  const InteractiveSearchScreen({super.key});

  @override
  State<InteractiveSearchScreen> createState() => _InteractiveSearchScreenState();
}

class _InteractiveSearchScreenState extends State<InteractiveSearchScreen> {
  // 1. Predefined products list
  final List<String> _allProducts = [
    'Sony Wireless Headphones',
    'Apple iPad Air',
    'Logitech Gaming Mouse',
    'Dell 4K Monitor',
    'Mechanical Keyboard',
    'Bluetooth Speaker',
  ];

  // 2. Filtered list variable
  List<String> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  // 3. Search filter method
  void _filterSearch(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter Products')),
      body: Column(
        children: [
          // Input Widget: TextField for live search
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                labelText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          // Interactive List of results
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.purple),
                        title: Text(_filteredProducts[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
```

---

## How to Run
```bash
cd exp3
flutter run
```
