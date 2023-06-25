import 'package:connectify/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/my_button.dart';
import '../utils/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});
  final void Function() onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordObscure = true;
  bool conPasswordObscure = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    String name1 = firstNameController.text.trim();
    //!first name manipulation
    String firstName =
        name1.substring(0, 1).toUpperCase() + name1.substring(1).toLowerCase();

    //!last name manipulation
    String name2 = lastNameController.text.trim();
    String lastName =
        name2.substring(0, 1).toUpperCase() + name2.substring(1).toLowerCase();

    Provider.of<AuthProvider>(context, listen: false).signUp(
        context,
        firstName,
        lastName,
        emailController.text.trim(),
        passwordController.text.trim(),
        confirmPasswordController.text.trim(),
        mobileNumberController.text.trim());
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/4232/4232893.png',
                  color: darkDesign,
                ),
                const SizedBox(height: 15),
                Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(fontSize: 35),
                ),
                Text(
                  'Connectify',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(fontSize: 45),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: MyTextfield(
                          controller: firstNameController,
                          hintText: 'First Name',
                          obscureText: false),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MyTextfield(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          obscureText: false),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextfield(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: MyTextfield(
                            controller: mobileNumberController,
                            hintText: 'Mobile Number',
                            keyboard: TextInputType.phone,
                            obscureText: false))
                  ],
                ),
                MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordObscure = !passwordObscure;
                          });
                        },
                        icon: Icon(
                          passwordObscure
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: darkDesign,
                        )),
                    obscureText: passwordObscure),
                MyTextfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    icon: IconButton(
                        onPressed: () {
                          setState(() {
                            conPasswordObscure = !conPasswordObscure;
                          });
                        },
                        icon: Icon(
                          conPasswordObscure
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: darkDesign,
                        )),
                    obscureText: conPasswordObscure),
                MyButton(
                  onTap: signUp,
                  buttonText: 'Register',
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?  '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login !',
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
