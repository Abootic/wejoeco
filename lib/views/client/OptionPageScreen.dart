import 'package:flutter/material.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import 'RegisterScreen.dart';
import 'RegisterPagecustomer.dart';
import 'LoginScreen.dart';


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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Registerpagecustomer(),
                  ),
                );
              },
              style: AppStyles.elevatedButtonStyle(AppColors.primary),
              child: const Text('If you are a Customer, Register here'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              style: AppStyles.elevatedButtonStyle(AppColors.primary),
              child: const Text('If you are a Supplier, Register here'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: AppStyles.elevatedButtonStyle(AppColors.primary),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}