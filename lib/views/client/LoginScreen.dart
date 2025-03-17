import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/LoginBloc.dart';
import '../../utilities/state_types.dart';
import 'DashBordScreen.dart';
import 'OptionPageScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _bloc = context.read<LoginBloc>();

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.currentState == StateTypes.submitted) {
            // Navigate to Dashboard on successful login
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashBoardScreen()),
            );
          } else if (state.currentState == StateTypes.error) {
            // Show an error dialog on login failure
            _showErrorDialog(state.error ?? "Something went wrong");
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            switch (state.currentState) {
              case StateTypes.loading:
                return _buildLoadingState();
              case StateTypes.error:
                return _buildErrorState(state.error ?? "An error occurred.");
              case StateTypes.submitting:
                return _buildSubmittingState();
              case StateTypes.init:
              case StateTypes.loaded:
                return _buildLoginForm(_bloc);
              default:
                return _buildLoginForm(_bloc); // Display login form by default
            }
          },
        ),
      ),
    );
  }

  // Error Dialog
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blueAccent),
          SizedBox(height: 10),
          Text("Loading..."),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          Text("Error: $errorMessage"),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Submitting State - show the loading indicator
  Widget _buildSubmittingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blueAccent),
          SizedBox(height: 10),
          Text("Submitting..."),
        ],
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm(LoginBloc bloc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              _buildEmailField(),
              SizedBox(height: 30),
              _buildPasswordField(),
              SizedBox(height: 30),
              _buildLoginButton(bloc),
              SizedBox(height: 30),
              _buildRegisterText(),
            ],
          ),
        ),
      ),
    );
  }

  // Email TextField
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your Email",
        labelText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );
  }

  // Password TextField
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your Password",
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
    );
  }

  // Login Button
  Widget _buildLoginButton(LoginBloc bloc) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState?.validate() ?? false) {
          // Only trigger login if the form is valid
          bloc.add(SubmitData(
            model: {
              'username': _emailController.text,
              'password': _passwordController.text,
            },
          ));
        }
      },
      child: Container(
        height: 35,
        width: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
      ),
    );
  }

  // Register Text Link
  Widget _buildRegisterText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Don't have an account?", style: TextStyle(color: Colors.black)),
          WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(
            text: "Register here",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
