# Experiment 6: Update Existing Records in Google Cloud Firestore

## Aim
Develop a Flutter application that allows users to update existing records stored in Google Cloud Firestore based on user input and displays the updated information dynamically.

---

## Key Cloud Firestore Update Concepts Used
- **Target Document Reference**:
  ```dart
  FirebaseFirestore.instance.collection('inventory').doc(documentId)
  ```
- **Updating Fields**:
  ```dart
  docRef.update({
    'name': newName,
    'price': newPrice,
    'stock': newStock,
  });
  ```
- **Real-Time Synchronized UI**: Using `StreamBuilder<QuerySnapshot>` to automatically re-render the UI the moment any record in Cloud Firestore is modified.

---

## Minimal Exam Bone Code (Memorize for Exam)

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirestoreUpdateScreen(),
    );
  }
}

class FirestoreUpdateScreen extends StatelessWidget {
  const FirestoreUpdateScreen({super.key});

  // 1. Method to update document in Firestore
  void _updatePrice(BuildContext context, String docId, double currentPrice) {
    final priceController = TextEditingController(text: currentPrice.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New Price (\$)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              double? newPrice = double.tryParse(priceController.text);
              if (newPrice != null) {
                // Update specific document field in Firestore
                await FirebaseFirestore.instance
                    .collection('inventory')
                    .doc(docId)
                    .update({'price': newPrice});
                Navigator.pop(ctx);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Firestore Records')),
      // 2. StreamBuilder to display real-time records
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name'] ?? ''),
                subtitle: Text('Price: \$${data['price']} • Stock: ${data['stock']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  onPressed: () => _updatePrice(context, doc.id, (data['price'] as num).toDouble()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## How to Run
```bash
cd exp6
flutter run
```
