import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photuu/main.dart';
import 'package:photuu/services/auth/auth_services.dart';
import 'package:photuu/services/auth_services.dart';
import 'package:photuu/utils/utils.dart';

import '../widgets/textfield_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/photuu_logo.png',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFieldInput(
                      controller: _emailController,
                      hintText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      isPassword: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFieldInput(
                      controller: _usernameController,
                      hintText: 'Username',
                      textInputType: TextInputType.emailAddress,
                      isPassword: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFieldInput(
                      controller: _passwordController,
                      hintText: 'Password',
                      textInputType: TextInputType.text,
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        color: Colors.blue,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              String res =
                                  await AuthServices.firebase().createUser(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginScreen, (route) => false);
                              if (mounted) {
                                showSnackBar(context, res);
                              }
                            },
                            child: const Text(
                              'Sign Up ',
                              style: TextStyle(color: Colors.white),
                            ))),
                    Flexible(
                      child: Container(),
                      flex: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Do not have an account? '),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginScreen, (route) => false);
                            },
                            child: const Text('Log In'))
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
    ;
  }
}
