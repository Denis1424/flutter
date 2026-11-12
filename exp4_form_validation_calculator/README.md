# Experiment 4: Form Validation using Stateful Widgets

## Aim
Design and implement a Car Mileage Calculator using Flutter Forms, `TextFormField`, Input Widgets, and Stateful Widgets. Validate user inputs and display the calculated mileage dynamically.

---

## Key Form & Validation Concepts Used
- **`Form`**: Encloses input fields to validate and manage form state collectively.
- **`GlobalKey<FormState>`**: Uniquely identifies the Form and triggers `_formKey.currentState!.validate()`.
- **`TextFormField` with `validator`**:
  - Non-empty validation (`value == null || value.isEmpty`).
  - Numeric check (`double.tryParse(value)`).
  - Business logic check: Ending odometer reading must be strictly greater than starting odometer reading.
  - Fuel quantity must be greater than zero.
- **Dynamic State Update**: Formula: $\text{Mileage} = \frac{\text{Ending Odometer} - \text{Starting Odometer}}{\text{Fuel Consumed}}$. Displays calculated values dynamically using `setState`.

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
      home: MileageCalculatorScreen(),
    );
  }
}

class MileageCalculatorScreen extends StatefulWidget {
  const MileageCalculatorScreen({super.key});

  @override
  State<MileageCalculatorScreen> createState() => _MileageCalculatorScreenState();
}

class _MileageCalculatorScreenState extends State<MileageCalculatorScreen> {
  // 1. Form key for validation
  final _formKey = GlobalKey<FormState>();

  // 2. Controllers
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _fuelController = TextEditingController();

  double? _mileage;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double start = double.parse(_startController.text);
      double end = double.parse(_endController.text);
      double fuel = double.parse(_fuelController.text);

      setState(() {
        _mileage = (end - start) / fuel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Mileage Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Starting Odometer
              TextFormField(
                controller: _startController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Starting Reading (km)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter start reading' : null,
              ),
              const SizedBox(height: 10),

              // Ending Odometer
              TextFormField(
                controller: _endController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ending Reading (km)'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter end reading';
                  double? end = double.tryParse(val);
                  double? start = double.tryParse(_startController.text);
                  if (end != null && start != null && end <= start) {
                    return 'End reading must be greater than start';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Fuel Consumed
              TextFormField(
                controller: _fuelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Fuel Added (Liters)'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter fuel volume';
                  double? fuel = double.tryParse(val);
                  if (fuel == null || fuel <= 0) return 'Fuel must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calculate Mileage'),
              ),
              const SizedBox(height: 20),

              // Dynamic Output
              if (_mileage != null)
                Text(
                  'Calculated Mileage: ${_mileage!.toStringAsFixed(2)} km/L',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## How to Run
```bash
cd exp4
flutter run
```
