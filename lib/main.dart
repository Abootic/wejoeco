import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejoeco/repositories/CustomerRepository.dart';
import 'package:wejoeco/repositories/LoginRepository.dart';
import 'package:wejoeco/repositories/MarketRepository.dart';
import 'package:wejoeco/repositories/ProductRepository.dart';
import 'package:wejoeco/repositories/SharedRepository.dart';
import 'package:wejoeco/repositories/SupplierRepository.dart';
import 'package:wejoeco/utilities/routes.dart';
import 'package:wejoeco/utilities/service_locator.dart';
import 'package:wejoeco/utilities/state_types.dart';
import 'package:get_it/get_it.dart';
import 'package:wejoeco/views/client/DashBordScreen.dart';
import 'package:wejoeco/views/client/LoginScreen.dart';
import 'package:wejoeco/views/client/ProfileScreen.dart'; // Include the ProfileScreen for navigation

import 'bloc/CustomerBloc.dart';
import 'bloc/LoginBloc.dart';
import 'apis/http_override.dart';
import 'bloc/MarketBloc.dart';
import 'bloc/ProductBloc.dart';
import 'bloc/SupplierBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) {
            final bloc = LoginBloc(repository: GetIt.instance<LoginRepository>());
            print("LoginBloc created in MyApp: ${bloc.hashCode}");
            bloc.add(CheckLoginStatusEvent()); // Check status on creation
            return bloc;
          },
        ),
        BlocProvider<SupplierBloc>(
          create: (_) => SupplierBloc(repository: GetIt.instance<SupplierRepository>()),
        ),
        BlocProvider<CustomersBloc>(
          create: (_) => CustomersBloc(repository: GetIt.instance<CustomerRepository>()),
        ),
        BlocProvider<MarketBloc>(
          create: (_) => MarketBloc(repository: GetIt.instance<MarketRepository>()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(repository: GetIt.instance<ProductRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: AppRoutes.generateRoute, // Use the generateRoute method
        initialRoute: Routes.profile, // Set the correct initial route
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    print("HomeScreen using LoginBloc: ${loginBloc.hashCode}");

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        print("BlocConsumer listener triggered with state: currentState = ${state.currentState}, authResponse = ${state.authResponse}");
        if (state.currentState == StateTypes.init && state.authResponse == null) {
          print("Condition met, navigating to LoginScreen from BlocConsumer");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
          );
          print("Navigation to LoginScreen dispatched from BlocConsumer");
        }
      },
      builder: (context, state) {
        return FutureBuilder<String?>(
          future: _getStoredToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final token = snapshot.data;
            print("FutureBuilder: token = $token, authResponse = ${loginBloc.state.authResponse}");
            if (token != null && token.isNotEmpty && loginBloc.state.authResponse != null) {
              return const DashBoardScreen();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }

  Future<String?> _getStoredToken() async {
    var shared = GetIt.instance<SharedRepository>();
    return await shared.getData("accessToken");
  }
}
