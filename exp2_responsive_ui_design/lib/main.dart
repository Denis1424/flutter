import 'package:flutter/material.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 2: TechStore Responsive Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResponsiveCatalogScreen(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final double price;
  final String icon;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
  });
}

class ResponsiveCatalogScreen extends StatefulWidget {
  const ResponsiveCatalogScreen({super.key});

  @override
  State<ResponsiveCatalogScreen> createState() => _ResponsiveCatalogScreenState();
}

class _ResponsiveCatalogScreenState extends State<ResponsiveCatalogScreen> {
  final List<Product> products = const [
    Product(name: 'Wireless Headphones', category: 'Electronics', price: 199.99, icon: '🎧'),
    Product(name: 'Smart Fitness Watch', category: 'Wearables', price: 299.00, icon: '⌚'),
    Product(name: 'Gaming Laptop', category: 'Computers', price: 1299.99, icon: '💻'),
    Product(name: 'Mechanical Keyboard', category: 'Accessories', price: 89.99, icon: '⌨️'),
    Product(name: 'Mirrorless Camera', category: 'Cameras', price: 849.50, icon: '📷'),
    Product(name: 'Ergonomic Office Chair', category: 'Furniture', price: 249.00, icon: '🪑'),
  ];

  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechStore Catalog'),
        backgroundColor: Colors.blue,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive Breakpoint: Phone (<600px) gets 2 columns, Tablet/Desktop (>=600px) gets 4 columns
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 2 : 4;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.blue.shade50,
                child: Text(
                  isMobile
                      ? 'Mobile View (Width: ${constraints.maxWidth.toInt()}px, 2 Columns)'
                      : 'Tablet/Desktop View (Width: ${constraints.maxWidth.toInt()}px, 4 Columns)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () {
                        setState(() {
                          _cartCount++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added ${product.name} to cart')),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Reusable Custom Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              product.icon,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              product.category,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
