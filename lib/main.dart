import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejoeco/repositories/LoginRepository.dart';
import 'package:wejoeco/repositories/MarketRepository.dart';
import 'package:wejoeco/repositories/SharedRepository.dart';
import 'package:wejoeco/repositories/SupplierRepository.dart';
import 'package:wejoeco/utilities/service_locator.dart';
import 'package:wejoeco/views/client/DashBordScreen.dart';
import 'package:wejoeco/views/client/LoginScreen.dart';

import 'bloc/LoginBloc.dart';
import 'apis/http_override.dart';
import 'bloc/MarketBloc.dart';
import 'bloc/SupplierBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setupDI();  // Ensure async DI setup is done
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredToken(), // Retrieve the stored token asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while fetching token
        }

        final token = snapshot.data;
        if (token != null && token.isNotEmpty) {
          // Token exists, navigate to home screen
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => MarketBloc(repository: getIt<MarketRepository>()),
              ),
              BlocProvider(
                create: (_) => LoginBloc(repository: getIt<LoginRepository>()),
              ),  BlocProvider(
                create: (_) => SupplierBloc(repository: getIt<SupplierRepository>()),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: const DashBoardScreen(), // Replace with the home screen widget
            ),
          );
        } else {
          // Token doesn't exist or is invalid, show the login screen
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LoginBloc(repository: getIt<LoginRepository>()),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: const LoginScreen(), // Login screen when no token is found
            ),
          );
        }
      },
    );
  }

  // Method to fetch the stored token
  Future<String?> _getStoredToken() async {
    var shared = getIt<SharedRepository>();
    return await shared.getData("accessToken");
  }
}
