# Experiment 2: Adaptive and Responsive UI Design

## Aim
Design and implement a responsive Flutter application for an E-Commerce Product Catalog by creating reusable custom product widgets. Ensure the application adapts to different screen sizes using responsive layout techniques (`LayoutBuilder` / `MediaQuery`).

---

## Key Responsive Concepts Used
- **`LayoutBuilder`**: Inspects parent box constraints (`constraints.maxWidth`) dynamically.
- **Breakpoints**:
  - Screen < 600px (Mobile) $\rightarrow$ 2 grid columns.
  - Screen $\ge$ 600px (Tablet/Desktop) $\rightarrow$ 4 grid columns.
- **`GridView.builder`**: Uses `SliverGridDelegateWithFixedCrossAxisCount` with dynamic `crossAxisCount`.
- **Reusable Custom Widget**: `ProductCard` renders each product uniformly across all screen sizes.

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
      home: ResponsiveCatalogScreen(),
    );
  }
}

// 1. Product Model
class Product {
  final String title;
  final String price;
  final IconData icon;

  const Product(this.title, this.price, this.icon);
}

// 2. Responsive Catalog Screen using LayoutBuilder
class ResponsiveCatalogScreen extends StatelessWidget {
  const ResponsiveCatalogScreen({super.key});

  final List<Product> products = const [
    Product('Laptop', '\$999', Icons.laptop),
    Product('Headphones', '\$199', Icons.headphones),
    Product('Smart Watch', '\$299', Icons.watch),
    Product('Camera', '\$599', Icons.camera_alt),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Catalog')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive Breakpoint: 2 columns on Mobile, 4 columns on Tablet/Desktop
          int columns = constraints.maxWidth < 600 ? 2 : 4;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}

// 3. Reusable Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(product.icon, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product.price, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
cd exp2
flutter run
```
