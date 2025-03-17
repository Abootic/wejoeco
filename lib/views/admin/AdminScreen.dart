
import 'package:flutter/material.dart';

import 'CustomerScreen.dart';
import 'MarketScreen.dart';
import 'SupplierScreen.dart';
import 'UsersScreen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Admin',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildListTile(context, 'Users', UsersScreen()),
          _buildListTile(context, 'Customer', CustomerScreen()),
          _buildListTile(context, 'Supplier', SupplierScreen()),
          _buildListTile(context, 'Market', MarketScreen()),
        ],
      ),
    );
  }

  // Helper method to create a ListTile with a clickable arrow
  Widget _buildListTile(BuildContext context, String title, Widget nextScreen) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward, color: Colors.blue),
        onPressed: () {
          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        },
      ),
    );
  }
}
