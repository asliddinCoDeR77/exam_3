import 'package:exam_3/views/screens/forget_password.dart';
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

class SocialMediaIcons2 extends StatelessWidget {
  const SocialMediaIcons2({super.key});

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

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const ForgetPassword();
              },
            ));
          },
          child: const Text('Forget password?',
              style: TextStyle(color: Color(0xff0095FF))),
        ),
      ],
    );
  }
}
