# Experiment 5: Retrieve Information from Google Cloud Firestore based on Search Input

## Aim
Design and implement a Flutter application that retrieves information from Google Cloud Firestore based on user search input and displays the corresponding records dynamically.

---

## Key Cloud Firestore Concepts Used
- **`Firebase.initializeApp()`**: Initializes Firebase before app launch.
- **`FirebaseFirestore.instance.collection('students')`**: Targets the Firestore collection.
- **Prefix Querying**:
  ```dart
  collection
    .where('name', isGreaterThanOrEqualTo: query)
    .where('name', isLessThanOrEqualTo: '$query\uf8ff')
    .snapshots();
  ```
- **`StreamBuilder<QuerySnapshot>`**: Subscribes to real-time query streams and handles loading, error, and empty states.
- **Dynamic Display**: Maps query snapshot documents (`doc['name']`, `doc['rollNo']`, `doc['cgpa']`) into a `ListView.builder`.

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
      home: FirestoreSearchScreen(),
    );
  }
}

class FirestoreSearchScreen extends StatefulWidget {
  const FirestoreSearchScreen({super.key});

  @override
  State<FirestoreSearchScreen> createState() => _FirestoreSearchScreenState();
}

class _FirestoreSearchScreenState extends State<FirestoreSearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 1. Build Firestore Query based on user search input
    Query query = FirebaseFirestore.instance.collection('students');
    if (_searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Student Search')),
      body: Column(
        children: [
          // 2. User Input Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: const InputDecoration(
                labelText: 'Search student by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 3. Dynamic StreamBuilder for Real-Time Firestore Retrieval
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No student records found'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: Text(data['name'] ?? ''),
                      subtitle: Text('Roll: ${data['rollNo']} • Dept: ${data['department']}'),
                      trailing: Text('CGPA: ${data['cgpa']}'),
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
```

---

## How to Run
```bash
cd exp5
flutter run
```
