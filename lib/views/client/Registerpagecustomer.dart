import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';




class Registerpagecustomer extends StatefulWidget {
  const Registerpagecustomer({super.key});

  @override
  State<Registerpagecustomer> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Registerpagecustomer> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Register for Customer",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Enter your phone number",
                    labelText: "phone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              SizedBox(height: 30),
              _buildButton(),
              SizedBox(height: 30),
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: "You Already have Account?",
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(text: "Login here",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
                              }
                        )
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        //TODO: LOGIN HERE
      },
      child: Container(
        height: 35,
        width: 120,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 23,),),
      ),
    );
  }
}
