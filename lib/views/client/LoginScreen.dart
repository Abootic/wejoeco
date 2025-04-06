import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/LoginBloc.dart';
import '../../main.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';
import '../wedgetHelper/reusable_widgets.dart';
import 'OptionPageScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _bloc = context.read<LoginBloc>();

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.currentState == StateTypes.submitted) {
            if (state.authResponse != null && state.authResponse!.success) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else {
              _showErrorDialog(state.error ?? "Login failed. Please try again.");
            }
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            switch (state.currentState) {
              case StateTypes.loading:
                return buildLoadingWidget();
              case StateTypes.submitting:
                return buildLoadingWidget();
              case StateTypes.error:
                return buildErrorWidget(state.error ?? "An error occurred.");
              default:
                return _buildLoginForm(context.read<LoginBloc>());
            }
          },
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginForm(LoginBloc bloc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildEmailField(),
              const SizedBox(height: 30),
              _buildPasswordField(),
              const SizedBox(height: 30),
              _buildLoginButton(bloc),
              const SizedBox(height: 30),
              _buildRegisterText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: AppStyles.inputDecoration("Email"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: AppStyles.inputDecoration("Password"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(LoginBloc bloc) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState?.validate() ?? false) {
          bloc.add(SubmitData(
            model: {
              'username': _emailController.text,
              'password': _passwordController.text,
            },
          ));
        }
      },
      child: Container(
        height: 50,
        width: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          color: AppColors.primary,
        ),
        child: const Text(
          "Login",
          style: TextStyle(color: AppColors.buttonText, fontSize: 23),
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: "Don't have an account?", style: TextStyle(color: AppColors.text)),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(
            text: "Register here",
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => OptionPageScreen()),
                );
              },
          ),
        ],
      ),
    );
  }
}