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
  bool? isFromGarage = false;
  final authProvider = locator<AuthProvider>();
  ProfilePage({Key? key, this.isFromGarage}) : super(key: key) {
    authProvider.getUserDetails();
  }

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
    getData();
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
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlatformFile? objFile;
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName;
  String? img;

  pickFile(AuthProvider model) async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        //imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        img = await imgProvider.uploadImage(
          "0",
          imageBytes: imageBytes,
          objectFile: objFile,
        );
        debugPrint("IMG::" + img!);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
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
            const Text("Type CONFIRM to permanently disable your account"),
            const SizedBox(height: 10),
            TextField(
              controller: confirmController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "CONFIRM",
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
        child: Consumer<AuthProvider>(
          builder: (context, model, child) => Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: DrawClip2(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                        // color: ColorResources.BUTTON_COLOR
                        gradient: LinearGradient(
                          colors: [Color(0xffa58fd2), Color(0xffddc3fc)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: DrawClip(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorResources.PRIMARY_COLOR,
                            Color(0xff91c5fc),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          model.user!.imageUrl.toString() == ""
                              ? Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[100],
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/images/my_profile.png',
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        model.user!.imageUrl.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                await pickFile(model);
                                await model.updateUser(image_url: img);
                              },
                              child: Container(
                                width: 35.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                CircleAvatar(radius: 60, backgroundImage: _profileImage(model)),
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
              RegistrationTextFeild(
                controller: mobileController,
                hintText: "Mobile Number",
                textInputType: TextInputType.phone,
                iconData: Icons.phone_android,
              ),
              RegistrationTextFeild(
                controller: emailController,
                hintText: "Email Id",
                textInputType: TextInputType.emailAddress,
                iconData: Icons.email,
              ),
              CustomButton(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (_) => new CupertinoAlertDialog(
                      title: Text(
                        'Are you sure want to update your profile?',
                        style: Style.heading,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('yes', style: Style.okButton),
                          onPressed: () {
                            model
                                .updateUser(
                                  first_name: fnameController.text,
                                  last_name: lnameController.text,
                                  mobilenumber: mobileController.text,
                                  emailid: emailController.text,
                                )
                                .then(
                                  (value) => {
                                    print(value),
                                    showAnimatedDialog(
                                      context,
                                      MyDialog(
                                        icon: Icons.check,
                                        title: 'Edit Profile',
                                        description:
                                            'Your Profile Updated successfully',
                                        isFailed: false,
                                      ),
                                      dismissible: false,
                                      isFlip: false,
                                    ),
                                  },
                                );
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('no', style: Style.cancelButton),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                buttonText: 'Save',
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Text(
                      "Address Details",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffea6935),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.customer_address);
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewAddress()),
                      );*/
                    },
                  ),
                  widget.isFromGarage == true
                      ? InkWell(
                          child: const Text(
                            "Garage Details",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffea6935),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.garage_info);
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GarageInfo()),);*/
                          },
                        )
                      : InkWell(
                          child: Text(
                            "Vehicle Details",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffea6935),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewVehicles(),
                              ),
                            );
                          },
                        ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  final TextEditingController confirmController =
                      TextEditingController();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "This action is permanent.\nTo confirm deletion, type CONFIRM below:",
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: confirmController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: "Type CONFIRM",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (confirmController.text.trim() == "CONFIRM") {
                                Navigator.pop(context); // close dialog

                                /// Call your delete method here
                                bool deleted = await authProvider.deleteAccount(
                                  authProvider.user!,
                                );

                                if (deleted) {
                                  showAnimatedDialog(
                                    context,
                                    MyDialog(
                                      icon: Icons.check,
                                      title: 'Account Deleted',
                                      description:
                                          'Your account has been removed permanently.',
                                      isFailed: false,
                                    ),
                                    dismissible: false,
                                    isFlip: false,
                                  );

                                  // Navigate to login or splash
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.login,
                                    (route) => false,
                                  );
                                }
                              } else {
                                /// Wrong input
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please type CONFIRM exactly to proceed.",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
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
  bool _isObscure = true;

  Widget input(String hint, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: TextFormField(
          obscureText: pass ? _isObscure : false,
          //obscuringCharacter: pass? '*' : '',
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
            contentPadding: EdgeInsets.only(top: 15, bottom: 15),
            prefixIcon: pass
                ? Icon(Icons.lock_outline, color: Colors.grey)
                : Icon(Icons.person_outline, color: Colors.grey),
            suffixIcon: pass
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      /*setState(() {
                          _isObscure = !_isObscure;
                        });*/
                    },
                  )
                : null,
            border: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        widget.isFromGarage == true
            ? InkWell(
                child: const Text(
                  "Garage Details",
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
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * .8,
      size.height * 0.8,
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
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
