import 'package:flutter/material.dart';

// Import your customer and supplier registration screens
import 'RegisterScreen.dart';// Replace with the actual path to your customer registration screen
import 'RegisterPagecustomer.dart'; // Replace with the actual path to your supplier registration screen

class OptionPageScreen extends StatelessWidget {
  const OptionPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select an option',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the customer registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Registerpagecustomer(),
                  ),
                );
              },
              child: const Text('If you are a Customer, Register here'),
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the supplier registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: const Text('If you are a Supplier, Register here'),
            ),
          ],
        ),
      ),
    );
  }
}