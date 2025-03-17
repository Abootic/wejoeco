import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Cart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // First Container with a different image
            _buildCartItem(
              'assets/Images/image1.png.jpg',
              'Factory Customized trendy big',
              'This is a trendy and customized product designed for modern fashion enthusiasts.',
            ),
            const SizedBox(height: 10), // Add spacing between containers
            // Second Container with a different image
            _buildCartItem(
              'assets/Images/image2.png.jpg',
              'Elegant Summer Dress',
              'A lightweight and elegant dress perfect for summer outings.',
            ),
            const SizedBox(height: 10), // Add spacing between containers
            // Third Container with a different image
            _buildCartItem(
              'assets/Images/image3.png.jpg',
              'Classic Leather Jacket',
              'A timeless leather jacket that adds a touch of sophistication to any outfit.',
            ),
            const SizedBox(height: 10), // Add spacing between containers
            // Fourth Container with a different image
            _buildCartItem(
              'assets/Images/image4.png.jpg',
              'Sporty Running Shoes',
              'Comfortable and durable running shoes designed for athletes.',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a cart item container with a custom image, name, and description
  Widget _buildCartItem(String imagePath, String productName, String description) {
    return Container(
      width: 400,
      height: 150, // Increased height to accommodate the description
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.white),
        boxShadow: const [BoxShadow(blurRadius: 8)],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset(imagePath), // Use the provided image path
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2, // Limit description to 2 lines
                    overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                  ),
                ),
                Spacer(), // Pushes the price and buttons to the bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Text(
                        'SAR 18.50',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(), // Adds space between price and buttons
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          // Handle delete action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: Colors.green),
                        onPressed: () {
                          // Handle add action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}