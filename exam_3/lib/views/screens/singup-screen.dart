import 'package:exam_3/views/screens/login_screen.dart';
import 'package:exam_3/views/widgets/sing_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exam_3/models/user_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usersViewModel = UsersViewmodel();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isPasswordConfirmVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void togglePasswordConfirmVisibility() {
    setState(() {
      isPasswordConfirmVisible = !isPasswordConfirmVisible;
    });
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await usersViewModel.register(
            emailController.text,
            passwordController.text,
            nameController.text,
            phoneController.text,
            nameController.text, []);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registration successful! Please login.")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
                  "Sign up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff222B45),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SignUpForm(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                passwordConfirmController: passwordConfirmController,
                nameController: nameController,
                phoneController: phoneController,
                isPasswordVisible: isPasswordVisible,
                isPasswordConfirmVisible: isPasswordConfirmVisible,
                togglePasswordVisibility: togglePasswordVisibility,
                togglePasswordConfirmVisibility:
                    togglePasswordConfirmVisibility,
                isLoading: isLoading,
                onSubmit: submit,
              ),
              const SizedBox(height: 20),
              const SocialMediaIcons(),
              const SizedBox(height: 10),
              const TermsAndConditionsText(),
            ],
          ),
        ),
      ),
    );
  }
}
