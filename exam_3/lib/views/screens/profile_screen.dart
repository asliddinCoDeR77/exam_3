import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exam_3/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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

  void _editProfile() async {
    final result = await _showEditProfileDialog(context, user);

    if (result != null) {
      final updatedName = result['name'];
      final updatedEmail = result['email'];
      final updatedPhone = result['phone'];

      if (updatedName != null && updatedEmail != null && updatedPhone != null) {
        setState(() {
          user?.update(updatedName, updatedEmail, updatedPhone);
        });

        await usersViewmodel.updateUser(
            updatedName, updatedEmail, updatedPhone);
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
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
            Text(user?.name ?? 'null',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff222B45))),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/location.svg'),
                    title: const Text('Delivery address'),
                    subtitle: const Text('NYC, Broadway ave 79'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/wallet.svg'),
                    title: const Text('Payment method'),
                    subtitle: const Text('Mastercard ****7890'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/language.svg'),
                    title: Text('Language'),
                    subtitle: const Text('English'),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/notification.svg'),
                    title: const Text('Notification'),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/promo.svg'),
                    title: const Text('Promo'),
                    subtitle: const Text(
                      'You have 2 new promo codes',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/terms.svg'),
                    title: const Text('Terms and conditions'),
                    onTap: () => _navigateToDetail,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/about.svg'),
                    title: const Text('About app'),
                    onTap: () => _navigateToDetail,
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
