import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/SupplierBloc.dart';
import '../../models/SupplierDTO.dart';
import '../../models/UserDTO.dart';
import '../../utilities/state_types.dart';
import '../wedgetHelper/app_colors.dart';
import '../wedgetHelper/app_styles.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state.currentState == StateTypes.submitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration Successful!")),
            );
            Navigator.pop(context);
          } else if (state.currentState == StateTypes.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register for Supplier",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(_nameController, "Name"),
                  SizedBox(height: 20),
                  _buildTextField(_emailController, "Email", TextInputType.emailAddress),
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
      decoration: AppStyles.inputDecoration(label),
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
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          color: AppColors.primary,
        ),
        child: state.currentState == StateTypes.submitting
            ? CircularProgressIndicator(color: AppColors.buttonText)
            : Text("Register", style: TextStyle(color: AppColors.buttonText, fontSize: 20)),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Already have an account? ", style: TextStyle(color: AppColors.text)),
          TextSpan(
            text: "Login here",
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      final supplierBloc = context.read<SupplierBloc>();

      UserDTO userDTO = UserDTO(
        username: _nameController.text,
        email: _emailController.text,
        userType: "SUPPLIER",
        password: _passwordController.text,
      );

      SupplierDTO supplierDTO = SupplierDTO(
        code: "ll",
        userDTO: userDTO,
        marketId: 17,
      );

      supplierBloc.add(SubmitData(model: supplierDTO.toJson()));
    }
  }
}