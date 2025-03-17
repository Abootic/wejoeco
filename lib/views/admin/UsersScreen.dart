import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  // Dummy list of users (replace with actual data from your backend)
  final List<Map<String, String>> users = const [
    {'name': 'John Doe', 'email': 'john.doe@example.com', 'role': 'Customer'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'role': 'Supplier'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com', 'role': 'Admin'},
    {'name': 'Bob Brown', 'email': 'bob.brown@example.com', 'role': 'Customer'},
    {'name': 'Charlie Davis', 'email': 'charlie.davis@example.com', 'role': 'Supplier'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Users',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          // Total number of users
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Users: ${users.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                // Implement search functionality here
              },
            ),
          ),
          // List of users
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      user['name']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user['email']!),
                    trailing: Text(
                      user['role']!,
                      style: TextStyle(
                        color: user['role'] == 'Admin' ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}