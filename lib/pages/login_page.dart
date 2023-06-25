import 'package:connectify/pages/forgot_password.dart';
import 'package:connectify/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/my_button.dart';
import '../utils/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});
  final void Function() onTap;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 5,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/4232/4232893.png',
                  color: darkDesign,
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome back!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(fontSize: 45),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false),
                MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: darkDesign,
                        )),
                    obscureText: isObscure),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: lightDesign, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false).signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        context);
                  },
                  buttonText: 'Login',
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?  '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'REGISTER !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: lightDesign),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
