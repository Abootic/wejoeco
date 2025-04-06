import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wejoeco/repositories/SupplierProfitRepository.dart';

import 'bloc/PercentageBloc.dart';
import 'bloc/SupplierProfitBloc.dart';
import 'repositories/CustomerRepository.dart';
import 'repositories/LoginRepository.dart';
import 'repositories/MarketRepository.dart';
import 'repositories/OrderRepository.dart';
import 'repositories/ProductRepository.dart';
import 'repositories/SharedRepository.dart';
import 'repositories/SupplierRepository.dart';
import 'repositories/PercentageRepository.dart';

import 'utilities/routes.dart';
import 'utilities/service_locator.dart';
import 'utilities/state_types.dart';

import 'views/client/DashBordScreen.dart';
import 'views/client/LoginScreen.dart';
import 'views/client/ProfileScreen.dart';

import 'bloc/CustomerBloc.dart';
import 'bloc/LoginBloc.dart';
import 'apis/http_override.dart';
import 'bloc/MarketBloc.dart';
import 'bloc/OrderBloc.dart';
import 'bloc/ProductBloc.dart';
import 'bloc/SupplierBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setupDI(); // Ensure dependency injection setup is completed before running app
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
            bloc.add(CheckLoginStatusEvent()); // Dispatch event on creation
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
        BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(repository: GetIt.instance<OrderRepository>()),
        ), BlocProvider<PercentageBloc>(
          create: (_) => PercentageBloc(repository: GetIt.instance<PercentageRepository>()),
        ),BlocProvider<SupplierProfitBloc>(
          create: (_) => SupplierProfitBloc(repository: GetIt.instance<SupplierProfitRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: Routes.home,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String?> _getStoredToken() async {
    var shared = GetIt.instance<SharedRepository>();
    return await shared.getData("accessToken");
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.currentState == StateTypes.init && state.authResponse == null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
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
}
