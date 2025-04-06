import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../repositories/SharedRepository.dart';
import '../../utilities/routes.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';
import 'AddProductScreen.dart';
import 'Cart_Screen.dart';
import 'DashBoardContent.dart';
import 'Totalprofit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> _bottomNavItems = [];
  List<Widget> _pages = [];

  final SharedRepository _sharedRepository = GetIt.instance<SharedRepository>();

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userType = await _sharedRepository.getData("userType") ?? "UNKNOWN";
    setState(() {
      _setupNavigation(userType.toUpperCase());
    });
  }

  void _setupNavigation(String userType) {
    _pages = [];
    _bottomNavItems = [];

    switch (userType) {
      case "ADMIN":
        _pages = [
          _buildAdminProfile(context),
          const DashBoardContent(),
          CartScreen(),
        ];
        _bottomNavItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "Admin"),
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ];
        break;

      case "CUSTOMER":
        _pages = [
          _buildCustomerProfile(context),
          const DashBoardContent(),
          CartScreen(),
        ];
        _bottomNavItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ];
        break;

      case "SUPPLIER":
        _pages = [
          _buildSupplierProfile(context),
          const DashBoardContent(),
          const AddProductScreen(),
          const TotalProfit(),
        ];
        _bottomNavItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.business), label: "Supplier"),
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add product"),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Totalprofit"),
        ];
        break;

      default:
        _pages = [buildErrorWidget("Invalid User Type")];
        _bottomNavItems = [];
    }

    setState(() {
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty || _selectedIndex >= _pages.length) {
      return buildLoadingWidget();
    }

    return Scaffold(
      // Removed the AppBar from here
      body: _pages[_selectedIndex],
      bottomNavigationBar: _bottomNavItems.isNotEmpty
          ? BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
      )
          : null,
    );
  }

  Widget _buildAdminProfile(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(context),
        _buildSectionHeader('Admin Section'),
        Expanded(
          child: ListView(
            children: [
              _buildListTile('Market', Icons.arrow_forward_ios, context, routeName: Routes.market),
              _buildListTile('Customer', Icons.arrow_forward_ios, context,routeName: Routes.CustomerScreen),
              _buildListTile('Supplier', Icons.arrow_forward_ios, context, routeName: Routes.SupplerScreen),
              _buildListTile('Products', Icons.arrow_forward_ios, context, routeName: Routes.addProduct),
              _buildListTile('Perecentage', Icons.arrow_forward_ios, context, routeName: Routes.PercentageScreen),
              _buildListTile('Order history', Icons.arrow_forward_ios, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerProfile(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildSupplierProfile(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(context),
        _buildSectionHeader('Supplier Section'),
        Expanded(
          child: ListView(
            children: [
              _buildListTile('Supplier Profile', Icons.arrow_forward_ios, context, routeName: Routes.supplier),
              _buildListTile('Products', Icons.arrow_forward_ios, context, routeName: Routes.addProduct),
              _buildListTile('Total profit', Icons.arrow_forward_ios, context, routeName: Routes.Totalprofit),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.borderRadius)),
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Row(
            children: [
              //CircleAvatar(radius: 40, backgroundImage: const AssetImage('assets/Images/image1.png.jpg')),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Asad Malik', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('1234567891', style: TextStyle(fontSize: 16, color: AppColors.hintText)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, BuildContext context, {String? routeName, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Icon(icon, size: 20, color: AppColors.primary),
        onTap: onTap ??
                () {
              if (routeName != null) {
                Navigator.pushNamed(context, routeName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title tapped!')));
              }
            },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }
}