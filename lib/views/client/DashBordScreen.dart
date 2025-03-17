import 'package:flutter/material.dart';

import 'Cart_Screen.dart';
import 'ProfileScreen.dart';
import 'SearchScreen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int currentindex = 0;
  final screens = [
    const DashBoardContent(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            currentindex == 0 ? 'Home' : '', // Show "Home" only on the Dashboard screen
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: screens[currentindex],
    );
  }
}

class DashBoardContent extends StatelessWidget {
  const DashBoardContent({super.key});

  @override
  Widget build(BuildContext context) {
    var arrNames = [
      'Clothes              ',
      'Shoes                ',
      'Electronics       ',
      'Toys                  ',
      'Mobiles             ',
      'Safety               ',
      'Foods                ',
    ];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: 150,
            height: 650,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2, color: Colors.white),
              boxShadow: const [BoxShadow(blurRadius: 8)],
            ),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Text(
                  arrNames[index],
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                );
              },
              itemCount: arrNames.length,
              separatorBuilder: (context, index) {
                return const Divider(height: 80, thickness: 4);
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProductRow(context, 'assets/Images/image8.png.jpg'),
                _buildProductRow(context, 'assets/Images/image6.png.jpg'),
                _buildProductRow(context, 'assets/Images/image1.png.jpg'),
                _buildProductRow(context, 'assets/Images/image2.png.jpg'),
                _buildProductRow(context, 'assets/Images/image7.png.jpg'),
                _buildProductRow(context, 'assets/Images/image4.png.jpg'),
                _buildProductRow(context, 'assets/Images/image3.png.jpg'),
                _buildProductRow(context, 'assets/Images/image5.png.jpg'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductRow(BuildContext context, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Row(
        children: [
          _buildProductItem(context, imagePath),
          _buildProductItem(context, imagePath), // Replace with appropriate image paths
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 8)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: 100,  // Adjusted width to fit
                  height: 65,
                  child: Image.asset(imagePath),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 1.0, left: 4.0, right: 4.0),
              child: Text(
                'Factory Customized trendy big head trending heavy width',
                style: TextStyle(fontSize: 5, color: Colors.grey),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 0.0, left: 4.0),
              child: Text(
                'SAR 18.50',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 0.0, left: 2.0),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '+Add to Cart',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
