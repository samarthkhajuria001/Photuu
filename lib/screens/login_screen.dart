import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/services/auth/auth_services.dart';
import 'package:photuu/services/user.dart';
import 'package:photuu/utils/colors.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/auth_services.dart';
import '../utils/utils.dart';
import '../widgets/textfield_input.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              ? Center(child: CircularProgressIndicator())
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
                                  await AuthServices.firebase().loginUser(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              setState(() {
                                _isLoading = false;
                              });
                              if (res == 'success') {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    homePage, (route) => false);
                              }

                              if (mounted) {
                                showSnackBar(context, res);
                              }
                              print(res);
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(color: primaryColor),
                            ))),
                    Flexible(
                      child: Container(),
                      flex: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Do not have an account? '),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  signUpScreen, (route) => false);
                            },
                            child: Text('Sign Up'))
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
