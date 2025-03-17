import 'package:flutter/material.dart';
import 'Supplier.dart';
import 'TotalProfit.dart'; // Ensure this import is correct

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          // Profile Container
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 450,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white),
                boxShadow: const [BoxShadow(blurRadius: 8)],
              ),
              child: Row(
                children: [
                  // Avatar for the picture
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 40, // Size of the avatar
                      backgroundImage: AssetImage(
                          'assets/Images/image1.png.jpg'), // Add your image path
                    ),
                  ),
                  // Column for name and ID
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Row for the name
                      const Text(
                        'Asad Malik', // Replace with the actual name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8), // Spacing between name and ID
                      // Text for the ID
                      Text(
                        '1234567891', // Replace with the actual ID
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // List of items
          Expanded(
            child: ListView(
              children: [
                _buildListTile('Market', Icons.arrow_forward_ios, context),
                _buildListTile('Customer', Icons.arrow_forward_ios, context),
                _buildListTile('Supplier', Icons.arrow_forward_ios, context, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Supplier()),
                  );
                }),
                _buildListTile('Products', Icons.arrow_forward_ios, context),
                _buildListTile('Total profit', Icons.arrow_forward_ios, context, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Totalprofit()),
                  );
                }),
                _buildListTile('Order history', Icons.arrow_forward_ios, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a ListTile with an arrow icon
  Widget _buildListTile(String title, IconData icon, BuildContext context, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(icon, size: 20),
      onTap: onTap ?? () {
        // Default behavior if onTap is not provided
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title tapped!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}