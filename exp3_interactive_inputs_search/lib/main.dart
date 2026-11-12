import 'package:flutter/material.dart';

void main() {
  runApp(const InteractiveSearchApp());
}

class InteractiveSearchApp extends StatelessWidget {
  const InteractiveSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 3: Interactive Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ProductSearchScreen(),
    );
  }
}

class CatalogItem {
  final String name;
  final String category;
  final double price;
  final String emoji;

  const CatalogItem({
    required this.name,
    required this.category,
    required this.price,
    required this.emoji,
  });
}

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final List<CatalogItem> _allProducts = const [
    CatalogItem(name: 'Sony WH-1000XM5 Headphones', category: 'Audio', price: 349.99, emoji: '🎧'),
    CatalogItem(name: 'Apple iPad Air M2', category: 'Tablets', price: 599.00, emoji: '📱'),
    CatalogItem(name: 'Logitech MX Master 3S', category: 'Accessories', price: 99.99, emoji: '🖱️'),
    CatalogItem(name: 'Dell UltraSharp 27" 4K Monitor', category: 'Monitors', price: 549.99, emoji: '🖥️'),
    CatalogItem(name: 'Keychron K2 Mechanical Keyboard', category: 'Accessories', price: 79.99, emoji: '⌨️'),
    CatalogItem(name: 'Bose SoundLink Flex Speaker', category: 'Audio', price: 149.00, emoji: '🔊'),
    CatalogItem(name: 'Samsung Galaxy Tab S9', category: 'Tablets', price: 699.99, emoji: '📲'),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Audio', 'Tablets', 'Accessories', 'Monitors'];

    final filteredProducts = _allProducts.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Product Finder'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Input Widget
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Products',
                hintText: 'Enter product name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Category Filter Dropdown
            Row(
              children: [
                const Text('Filter by Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(),

            // Product List
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products found matching criteria.'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Text(
                              product.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Category: ${product.category}'),
                            trailing: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
