import 'package:exam_3/models/user_viewmodel.dart';
import 'package:exam_3/views/screens/login_screen.dart';
import 'package:exam_3/views/widgets/sing_up_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usersViewModel = UsersViewmodel();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final surnameController = TextEditingController();
  final cardsController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isPasswordConfirmVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    surnameController.dispose();
    cardsController.dispose();
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
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          phoneController.text.trim(),
          surnameController.text.trim(),
          cardsController.text.split(',').map((e) => e.trim()).toList(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful! Please login."),
          ),
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
                nameController: nameController,
                phoneController: phoneController,
                isPasswordVisible: isPasswordVisible,
                isPasswordConfirmVisible: isPasswordConfirmVisible,
                isLoading: isLoading,
                onSubmit: submit,
                passwordConfirmController: passwordController,
                togglePasswordVisibility: togglePasswordVisibility,
                togglePasswordConfirmVisibility:
                    togglePasswordConfirmVisibility,
                surnameController: surnameController,
                cardsController: cardsController,
              ),
              const SizedBox(height: 20),
              SocialMediaIcons(),
              const SizedBox(height: 20),
              TermsAndConditionsText(),
            ],
          ),
        ),
      ),
    );
  }
}
