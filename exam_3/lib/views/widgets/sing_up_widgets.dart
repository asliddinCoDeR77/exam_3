import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? toggleVisibility;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.toggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xffC5CEE0),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xffC5CEE0),
                width: 2.0,
              ),
            ),
            border: const OutlineInputBorder(),
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xffC5CEE0)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/eyes.svg',
                      width: 20,
                      color: isPasswordVisible ? Colors.blue : Colors.grey,
                    ),
                    onPressed: toggleVisibility,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isPasswordVisible;
  final bool isPasswordConfirmVisible;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback togglePasswordConfirmVisibility;
  final bool isLoading;
  final VoidCallback onSubmit;

  const SignUpForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.nameController,
    required this.phoneController,
    required this.isPasswordVisible,
    required this.isPasswordConfirmVisible,
    required this.togglePasswordVisibility,
    required this.togglePasswordConfirmVisibility,
    required this.isLoading,
    required this.onSubmit,
    required TextEditingController surnameController,
    required TextEditingController cardsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Password Confirm',
            controller: passwordConfirmController,
            hintText: 'Password confirm',
            isPassword: true,
            isPasswordVisible: isPasswordConfirmVisible,
            toggleVisibility: togglePasswordConfirmVisibility,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please confirm your password";
              }
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const Text(
            'At least one number and caps letter',
            style: TextStyle(color: Color(0xff8F9BB3)),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Name',
            controller: nameController,
            hintText: 'Name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your name";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Phone Number',
            controller: phoneController,
            hintText: 'Phone Number',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your phone number";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFC34A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/google.svg',
            width: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/facebook.svg',
            width: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/apple.svg',
            width: 30,
          ),
        ),
      ],
    );
  }
}

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'By signing up you agree',
          style: TextStyle(color: Color(0xff8F9BB3)),
        ),
        SizedBox(width: 10),
        Text(
          'terms and conditions',
          style: TextStyle(color: Color(0xff0095FF)),
        ),
      ],
    );
  }
}
