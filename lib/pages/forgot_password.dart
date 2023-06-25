import 'package:connectify/provider/auth_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:connectify/utils/my_button.dart';
import 'package:connectify/utils/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  void resetPassword() {
    Provider.of<AuthProvider>(context)
        .resetPassword(context, emailController.text.trim());
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Text(
                'RESET PASSWORD',
                style: GoogleFonts.bebasNeue(fontSize: 40),
                textAlign: TextAlign.center,
              ),
              const Text(
                  'Enter your email and we will send you you a password reset link'),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false),
              MyButton(buttonText: 'Send', onTap: resetPassword)
            ],
          ),
        )),
      ),
    );
  }
}
