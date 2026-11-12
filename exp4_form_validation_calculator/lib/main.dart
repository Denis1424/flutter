import 'package:flutter/material.dart';

void main() {
  runApp(const MileageCalculatorApp());
}

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 4: Mileage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MileageCalculatorScreen(),
    );
  }
}

class MileageCalculatorScreen extends StatefulWidget {
  const MileageCalculatorScreen({super.key});

  @override
  State<MileageCalculatorScreen> createState() => _MileageCalculatorScreenState();
}

class _MileageCalculatorScreenState extends State<MileageCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _startOdoController = TextEditingController();
  final TextEditingController _endOdoController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();

  double? _distance;
  double? _mileage;

  @override
  void dispose() {
    _startOdoController.dispose();
    _endOdoController.dispose();
    _fuelController.dispose();
    super.dispose();
  }

  void _calculateMileage() {
    if (_formKey.currentState!.validate()) {
      final start = double.parse(_startOdoController.text.trim());
      final end = double.parse(_endOdoController.text.trim());
      final fuel = double.parse(_fuelController.text.trim());

      final distance = end - start;
      final mileage = distance / fuel;

      setState(() {
        _distance = distance;
        _mileage = mileage;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _startOdoController.clear();
    _endOdoController.clear();
    _fuelController.clear();
    setState(() {
      _distance = null;
      _mileage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Mileage Calculator'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Trip & Fuel Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Start Odometer Field
              TextFormField(
                controller: _startOdoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Starting Odometer (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter starting odometer reading';
                  }
                  final val = double.tryParse(value.trim());
                  if (val == null || val < 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // End Odometer Field
              TextFormField(
                controller: _endOdoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ending Odometer (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter ending odometer reading';
                  }
                  final endVal = double.tryParse(value.trim());
                  if (endVal == null) {
                    return 'Please enter a valid number';
                  }
                  final startVal = double.tryParse(_startOdoController.text.trim());
                  if (startVal != null && endVal <= startVal) {
                    return 'Ending reading must be greater than starting reading';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Fuel Consumed Field
              TextFormField(
                controller: _fuelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fuel Consumed (Litres)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter fuel quantity';
                  }
                  final val = double.tryParse(value.trim());
                  if (val == null || val <= 0) {
                    return 'Fuel must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculateMileage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Calculate Mileage', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Reset', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Calculation Results Card
              if (_mileage != null)
                Card(
                  color: Colors.teal.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calculation Result',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const Divider(),
                        Text(
                          'Total Distance: ${_distance!.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mileage: ${_mileage!.toStringAsFixed(2)} km/L',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
