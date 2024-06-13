import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:exam_3/views/screens/login_screen.dart';
import 'package:exam_3/views/screens/profile_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late Timer _timer;
  int _start = 105;
  bool _isButtonEnabled = false;
  bool _isCodeComplete = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 105;
    _isButtonEnabled = false;
    setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resending code...')),
    );

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icons/arrow_back.svg'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Reset code',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xff222B45)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'We sent a 6-digit code to +1 234 567 89 00',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff222B45)),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            Pinput(
              length: 6,
              onCompleted: (value) {
                setState(() {
                  _isCodeComplete = value.length == 6;
                });
              },
              onChanged: (value) {
                setState(() {
                  _isCodeComplete = value.length == 6;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Didn’t get the code?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff28f9bb3)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timerText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: _start > 0 ? Colors.blue : Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: _isButtonEnabled ? resendCode : null,
                  child: Text(
                    'Resend',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color:
                          _isButtonEnabled ? Colors.blue : Color(0xff28f9bb3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 42,
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                onPressed: _isCodeComplete
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _isCodeComplete ? const Color(0xff8F9BB3) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ));
              },
              child: const Text(
                'Return to login',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
