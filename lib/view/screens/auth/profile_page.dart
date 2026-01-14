import 'dart:io';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/CustomAppBar-.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:carcheks/view/screens/customer/vehicle/view_vehicles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final bool? isFromGarage;
  const ProfilePage({super.key, this.isFromGarage});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authProvider = locator<AuthProvider>();

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await authProvider.getUserDetails();
    final user = authProvider.user;

    if (user != null) {
      fnameController.text = user.firstName ?? "";
      lnameController.text = user.lastName ?? "";
      emailController.text = user.emailid ?? "";
      mobileController.text = user.mobilenumber ?? "";
    }
    setState(() {});
  }

  /// PROFILE IMAGE PROVIDER (LOCAL → NETWORK → ASSET)
  ImageProvider _profileImage(AuthProvider provider) {
    if (provider.localProfileImg != null) {
      return FileImage(provider.localProfileImg!);
    }

    final img = provider.user?.imageUrl;
    if (img == null || img.isEmpty) {
      return const AssetImage("assets/images/my_profile.png");
    }

    return NetworkImage(img);
  }

  /// CHANGE PROFILE IMAGE
  Future<void> _changeProfileImage(AuthProvider provider) async {
    final imageUrl = await provider.pickAndUploadImage(
      context,
      true, // profile image
    );

    if (imageUrl != null) {
      await provider.updateUser(image_url: imageUrl);
    }
  }

  /// DELETE ACCOUNT
  Future<void> _deleteAccount() async {
    final confirmController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Type CONFIRM to disable your account"),
            const SizedBox(height: 10),
            TextField(
              controller: confirmController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "CONFIRM",
                hintStyle: TextStyle(color: Colors.black12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context);

              if (confirmController.text.trim() != "CONFIRM") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please type CONFIRM exactly"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final success = await authProvider.deleteAccount(
                authProvider.user!,
                context,
              );

              if (!success) return;

              showAnimatedDialog(
                context,
                MyDialog(
                  icon: Icons.check,
                  title: "Account Disabled",
                  description: "Your account has been disabled successfully.",
                  isFailed: false,
                ),
                dismissible: false,
                isFlip: false,
              );

              await Future.delayed(const Duration(seconds: 1));

              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    if (model.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBarWidgetTwo(context, GlobalKey(), "Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(size, model),
            const SizedBox(height: 12),

            RegistrationTextFeild(
              controller: fnameController,
              iconData: Icons.person,
              hintText: "First Name",
              textInputType: TextInputType.name,
            ),
            RegistrationTextFeild(
              controller: lnameController,
              iconData: Icons.person,
              hintText: "Last Name",
              textInputType: TextInputType.name,
            ),
            RegistrationTextFeild(
              controller: mobileController,
              iconData: Icons.phone_android,
              hintText: "Mobile Number",
              textInputType: TextInputType.phone,
            ),
            RegistrationTextFeild(
              controller: emailController,
              iconData: Icons.email,
              hintText: "Email ID",
              textInputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            CustomButton(
              buttonText: "Save",
              isEnable: true,
              onTap: () async {
                await model.updateUser(
                  first_name: fnameController.text,
                  last_name: lnameController.text,
                  mobilenumber: mobileController.text,
                  emailid: emailController.text,
                );

                showAnimatedDialog(
                  context,
                  MyDialog(
                    icon: Icons.check,
                    title: "Profile Updated",
                    description: "Your profile has been updated successfully.",
                    isFailed: false,
                  ),
                  dismissible: false,
                  isFlip: false,
                );
              },
            ),

            const SizedBox(height: 20),
            _links(context),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Disable Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// HEADER
  Widget _header(Size size, AuthProvider model) {
    return Stack(
      children: [
        ClipPath(
          clipper: DrawClip2(),
          child: Container(
            height: size.height * 0.28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffa58fd2), Color(0xffddc3fc)],
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: DrawClip(),
          child: Container(
            height: size.height * 0.28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorResources.PRIMARY_COLOR, Color(0xff91c5fc)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          width: size.width,
          child: Center(
            child: Stack(
              children: [
                Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage(model),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => _changeProfileImage(model),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _links(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          child: const Text(
            "Address Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Color(0xffea6935),
            ),
          ),
          onTap: () => Navigator.pushNamed(ctx, AppRoutes.customer_address),
        ),
        widget.isFromGarage == true
            ? InkWell(
                child: const Text(
                  "Business Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Color(0xffea6935),
                  ),
                ),
                onTap: () => Navigator.pushNamed(ctx, AppRoutes.garage_info),
              )
            : InkWell(
                child: const Text(
                  "Vehicle Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Color(0xffea6935),
                  ),
                ),
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(builder: (_) => ViewVehicles()),
                ),
              ),
      ],
    );
  }
}

/// CLIPPERS (UNCHANGED)
class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * .8);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * .8,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(_) => true;
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * .8);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * .9,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(_) => true;
}
