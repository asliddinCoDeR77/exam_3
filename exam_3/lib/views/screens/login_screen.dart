import 'package:exam_3/models/user_viewmodel.dart';
import 'package:exam_3/views/screens/profile_screen.dart';
import 'package:exam_3/views/screens/singup-screen.dart';
import 'package:exam_3/views/widgets/log_in_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usersViewModel = UsersViewmodel();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await usersViewModel.login(
          emailController.text,
          passwordController.text,
        );

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const ProfileScreen();
            },
          ),
        );
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
            );
          },
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const SignUpScreen();
              },
            ));
          },
          icon: SvgPicture.asset('assets/icons/arrow_back.svg'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      hintText: 'Email',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      isPasswordVisible: isPasswordVisible,
                      toggleVisibility: togglePasswordVisibility,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    const Text(
                      'At least one number and caps letter',
                      style: TextStyle(color: Color(0xff8F9BB3)),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFFC34A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Log in",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'or',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8F9BB3),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SocialMediaIcons2(),
              const SizedBox(height: 10),
              const ForgotPasswordLink(),
            ],
          ),
        ),
      ),
    );
  }
}
