import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/CustomerBloc.dart';
import '../../models/CustomerDTO.dart';
import '../../models/UserDTO.dart';
import '../../utilities/state_types.dart';


class Registerpagecustomer extends StatefulWidget {
  const Registerpagecustomer({super.key});

  @override
  State<Registerpagecustomer> createState() => _RegisterpagecustomerState();
}

class _RegisterpagecustomerState extends State<Registerpagecustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CustomersBloc, SupplierState>(
        listener: (context, state) {
          if (state.currentState == StateTypes.submitted) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Customer Registered Successfully!")),
            );
            Navigator.pop(context); // Navigate back after success
          } else if (state.currentState == StateTypes.error) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register for Customer",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(_nameController, "Name"),
                  SizedBox(height: 20),
                  _buildTextField(_emailController, "Email", TextInputType.emailAddress),
                  SizedBox(height: 20),
                  _buildTextField(_phoneController, "Phone", TextInputType.phone),
                  SizedBox(height: 20),
                  _buildTextField(_passwordController, "Password", TextInputType.visiblePassword),
                  SizedBox(height: 30),
                  _buildButton(state),
                  SizedBox(height: 20),
                  _buildLoginLink(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      [TextInputType keyboardType = TextInputType.text, bool obscureText = false]
      ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }

  Widget _buildButton(SupplierState state) {
    return GestureDetector(
      onTap: state.currentState == StateTypes.submitting ? null : _onRegister,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: state.currentState == StateTypes.submitting
            ? CircularProgressIndicator(color: Colors.white)
            : Text("Register", style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black)),
          TextSpan(
            text: "Login here",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      final customersBloc = context.read<CustomersBloc>();

      // Create UserDTO for customer
      UserDTO userDTO = UserDTO(
        username: _nameController.text,
        email: _emailController.text,
        userType: "CUSTOMER",
        password: _passwordController.text,
      );

      // Create CustomerDTO
      CustomerDTO customerDTO = CustomerDTO(
        code: "ss",
        phoneNumber: _phoneController.text,
        userDto: userDTO,
      );

      // Dispatch event
      customersBloc.add(SubmitData(model: customerDTO.toJson()));
    }
  }
}
