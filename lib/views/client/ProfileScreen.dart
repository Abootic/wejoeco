import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/routes.dart';
import 'Cart_Screen.dart';
import 'DashBoardContent.dart'; // Assuming this is the class for Dashboard

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Text("Admin Profile"), // Placeholder for Admin Profile
    const Text("Customer Profile"), // Placeholder for Customer Profile
    const Text("Supplier Profile"), // Placeholder for Supplier Profile
    const DashBoardContent(),  // DashBoardScreen
    const CartScreen(),  // CartScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective screens based on the index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, Routes.market);  // Admin screen
        break;
      case 1:
        Navigator.pushNamed(context, Routes.supplier);  // Customer screen
        break;
      case 2:
        Navigator.pushNamed(context, Routes.addProduct);  // Supplier screen
        break;
      case 3:
        Navigator.pushNamed(context, Routes.dashboard);  // Dashboard screen
        break;
      case 4:
        Navigator.pushNamed(context, Routes.cart);  // Cart screen
        break;
      default:
        Navigator.pushNamed(context, Routes.profile);  // Default profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final SharedRepository sharedRepository = GetIt.instance<SharedRepository>();

    return FutureBuilder<String?>(
      future: sharedRepository.getData("userType"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userType = snapshot.data?.toUpperCase() ?? "UNKNOWN";
        print("UserType fetched: $userType");

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile Screen', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          body: _getProfileScreen(userType, context),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Customer',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Supplier',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,  // Keep the fixed type like in DashBoardScreen
          ),
        );
      },
    );
  }

  Widget _getProfileScreen(String userType, BuildContext context) {
    final profileScreens = {
      "ADMIN": _buildAdminProfile,
      "CUSTOMER": _buildCustomerProfile,
      "SUPPLIER": _buildSupplierProfile,
    };

    final profileScreen = profileScreens[userType] ?? _buildUnknownProfile;
    return profileScreen(context);
  }

  Widget _buildAdminProfile(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileHeader(context),
          _buildSectionHeader('Admin Section'),
          Expanded(
            child: ListView(
              children: [
                _buildListTile('Market', Icons.arrow_forward_ios, context, routeName: Routes.market),
                _buildListTile('Customer', Icons.arrow_forward_ios, context),
                _buildListTile('Supplier', Icons.arrow_forward_ios, context, routeName: Routes.supplier),
                _buildListTile('Products', Icons.arrow_forward_ios, context, routeName: Routes.addProduct),
                _buildListTile('Total profit', Icons.arrow_forward_ios, context),
                _buildListTile('Order history', Icons.arrow_forward_ios, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerProfile(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileHeader(context),
          _buildSectionHeader('Customer Dashboard'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome, Customer!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildListTile('Customer Dashboard', Icons.arrow_forward_ios, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierProfile(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProfileHeader(context),
          _buildSectionHeader('Supplier Section'),
          Expanded(
            child: ListView(
              children: [
                _buildListTile('Supplier', Icons.arrow_forward_ios, context, routeName: Routes.supplier),
                _buildListTile('Products', Icons.arrow_forward_ios, context, routeName: Routes.addProduct),
                _buildListTile('Total profit', Icons.arrow_forward_ios, context, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Total Profit screen tapped!')));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnknownProfile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Profile Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
      body: const Center(
        child: Text('Unknown User Type. Please log in again.', style: TextStyle(fontSize: 18, color: Colors.red)),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(radius: 40, backgroundImage: const AssetImage('assets/Images/image1.png.jpg')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Asad Malik', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Text('1234567891', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, BuildContext context, {String? routeName, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
      trailing: Icon(icon, size: 20),
      onTap: onTap ?? () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title tapped!'), duration: const Duration(seconds: 1)));
        }
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }
}
