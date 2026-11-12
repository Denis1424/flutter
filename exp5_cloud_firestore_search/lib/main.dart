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
  runApp(FirestoreSearchApp(isFirebaseInitialized: firebaseReady));
}

class FirestoreSearchApp extends StatelessWidget {
  final bool isFirebaseInitialized;

  const FirestoreSearchApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 5: Firestore Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: FirestoreSearchScreen(isFirebaseConnected: isFirebaseInitialized),
    );
  }
}

class StudentRecord {
  final String id;
  final String rollNo;
  final String name;
  final String department;
  final double cgpa;

  StudentRecord({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.department,
    required this.cgpa,
  });

  factory StudentRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentRecord(
      id: doc.id,
      rollNo: data['rollNo'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      cgpa: (data['cgpa'] is num) ? (data['cgpa'] as num).toDouble() : 0.0,
    );
  }
}

class FirestoreSearchScreen extends StatefulWidget {
  final bool isFirebaseConnected;

  const FirestoreSearchScreen({super.key, required this.isFirebaseConnected});

  @override
  State<FirestoreSearchScreen> createState() => _FirestoreSearchScreenState();
}

class _FirestoreSearchScreenState extends State<FirestoreSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Local dataset for demo or testing mode
  final List<StudentRecord> _localRecords = [
    StudentRecord(id: '1', rollNo: 'CS101', name: 'Aarav Sharma', department: 'Computer Science', cgpa: 9.2),
    StudentRecord(id: '2', rollNo: 'CS102', name: 'Diya Patel', department: 'Computer Science', cgpa: 8.9),
    StudentRecord(id: '3', rollNo: 'EC201', name: 'Rohan Verma', department: 'Electronics', cgpa: 8.5),
    StudentRecord(id: '4', rollNo: 'IT301', name: 'Ananya Iyer', department: 'Information Tech', cgpa: 9.5),
    StudentRecord(id: '5', rollNo: 'ME401', name: 'Vikram Singh', department: 'Mechanical', cgpa: 7.8),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Record Search'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Student by Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 12),

            // Live Firestore StreamBuilder or Local Demo List
            Expanded(
              child: widget.isFirebaseConnected
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('students').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final docs = snapshot.data?.docs ?? [];
                        final students = docs
                            .map((doc) => StudentRecord.fromFirestore(doc))
                            .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                            .toList();

                        return _buildStudentList(students);
                      },
                    )
                  : _buildStudentList(
                      _localRecords
                          .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(List<StudentRecord> students) {
    if (students.isEmpty) {
      return const Center(child: Text('No student records found.'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrange.shade100,
              child: Text(
                student.name.isNotEmpty ? student.name[0] : '?',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
            ),
            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Roll: ${student.rollNo} • Dept: ${student.department}'),
            trailing: Text(
              'CGPA: ${student.cgpa}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
