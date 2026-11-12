import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase not configured natively. Using fallback data.');
  }
  runApp(FirestoreUpdateApp(isFirebaseInitialized: firebaseReady));
}

class FirestoreUpdateApp extends StatelessWidget {
  final bool isFirebaseInitialized;

  const FirestoreUpdateApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 6: Update Firestore Records',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: FirestoreUpdateScreen(isFirebaseConnected: isFirebaseInitialized),
    );
  }
}

class InventoryItem {
  final String id;
  String name;
  String category;
  double price;
  int stock;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
      stock: (data['stock'] is num) ? (data['stock'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
    };
  }
}

class FirestoreUpdateScreen extends StatefulWidget {
  final bool isFirebaseConnected;

  const FirestoreUpdateScreen({super.key, required this.isFirebaseConnected});

  @override
  State<FirestoreUpdateScreen> createState() => _FirestoreUpdateScreenState();
}

class _FirestoreUpdateScreenState extends State<FirestoreUpdateScreen> {
  final List<InventoryItem> _localInventory = [
    InventoryItem(id: '1', name: 'Logitech Mechanical Keyboard', category: 'Hardware', price: 89.99, stock: 15),
    InventoryItem(id: '2', name: 'Dell UltraSharp Monitor 27"', category: 'Electronics', price: 499.00, stock: 8),
    InventoryItem(id: '3', name: 'Ergonomic Standing Desk', category: 'Furniture', price: 320.50, stock: 3),
    InventoryItem(id: '4', name: 'Sony Wireless ANC Headset', category: 'Audio', price: 249.99, stock: 10),
  ];

  Future<void> _updateRecord(InventoryItem item, double newPrice, int newStock) async {
    if (widget.isFirebaseConnected) {
      await FirebaseFirestore.instance.collection('inventory').doc(item.id).update({
        'price': newPrice,
        'stock': newStock,
      });
    } else {
      setState(() {
        item.price = newPrice;
        item.stock = newStock;
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated "${item.name}" successfully!')),
      );
    }
  }

  void _showEditDialog(InventoryItem item) {
    final priceController = TextEditingController(text: item.price.toStringAsFixed(2));
    final stockController = TextEditingController(text: item.stock.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price (\$)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newPrice = double.tryParse(priceController.text.trim());
                final int? newStock = int.tryParse(stockController.text.trim());

                if (newPrice != null && newStock != null) {
                  _updateRecord(item, newPrice, newStock);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Firestore Records'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: widget.isFirebaseConnected
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                final items = docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();

                return _buildList(items);
              },
            )
          : _buildList(_localInventory),
    );
  }

  Widget _buildList(List<InventoryItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Category: ${item.category}\nPrice: \$${item.price.toStringAsFixed(2)} | Stock: ${item.stock} units'),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: () => _showEditDialog(item),
            ),
          ),
        );
      },
    );
  }
}
