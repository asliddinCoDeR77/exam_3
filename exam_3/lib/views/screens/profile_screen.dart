import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:exam_3/models/user.dart';
import 'package:exam_3/models/user_viewmodel.dart';
import 'package:exam_3/views/screens/promocode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  final UsersViewmodel usersViewmodel = UsersViewmodel();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await usersViewmodel.loadUserFromPreferences();
    setState(() {
      user = usersViewmodel.currentUser;
    });
  }

  Future<void> _editProfile() async {
    final result = await _showEditProfileDialog(context, user);

    if (result != null) {
      final updatedName = result['name'];
      final updatedEmail = result['email'];
      final updatedPhone = result['phone'];

      if (updatedName != null && updatedEmail != null && updatedPhone != null) {
        setState(() {
          user = user?.copyWith(
            name: updatedName,
            email: updatedEmail,
            phone: updatedPhone,
          );
        });

        await usersViewmodel.saveUserToPreferences(user!);

        await usersViewmodel.updateUserOnFirebase(user!);
      }
    }
  }

  Future<Map<String, String>?> _showEditProfileDialog(
      BuildContext context, User? currentUser) async {
    final nameController = TextEditingController(text: currentUser?.name ?? '');
    final emailController =
        TextEditingController(text: currentUser?.email ?? '');
    final phoneController =
        TextEditingController(text: currentUser?.phone ?? '');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetail(String title, String subtitle) {
    // Implement navigation logic as needed
  }

  // Method to change theme
  void _changeTheme(BuildContext context) {
    final themeMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
        ? AdaptiveThemeMode.dark
        : AdaptiveThemeMode.light;
    AdaptiveTheme.of(context).setThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _changeTheme(context), // Call _changeTheme method
            icon: SvgPicture.asset(
                'assets/icons/theme.svg'), // Replace with your theme change icon
          ),
          IconButton(
            onPressed: _editProfile,
            icon: SvgPicture.asset('assets/icons/edit.svg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child:
                  Image.asset('assets/images/boy.png', width: 100, height: 100),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'null',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xff222B45),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/location.svg'),
                    title: const Text('Delivery address'),
                    subtitle: const Text('NYC, Broadway ave 79'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail(
                        'Delivery address', 'NYC, Broadway ave 79'),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/wallet.svg'),
                    title: const Text('Payment method'),
                    subtitle: const Text('Mastercard ****7890'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail(
                        'Payment method', 'Mastercard ****7890'),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/language.svg'),
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    onTap: () => _navigateToDetail('Language', 'English'),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/notification.svg'),
                    title: const Text('Notification'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail('Notification', ''),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/promo.svg'),
                    title: const Text('Promo'),
                    subtitle: const Text(
                      'You have 2 new promo codes',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Promoccode())), // Navigate to PromoCodeScreen
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/terms.svg'),
                    title: const Text('Terms and conditions'),
                    onTap: () => _navigateToDetail('Terms and conditions', ''),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/logout.svg'),
                    title: const Text('Log out'),
                    onTap: () async {
                      await usersViewmodel.saveUserToPreferences(User(
                        id: '',
                        email: '',
                        password: '',
                        token: '',
                        expiryDate: DateTime.now(),
                        name: '',
                        phone: '',
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
