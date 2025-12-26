import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:carcheks/view/screens/auth/address_page.dart';
import 'package:carcheks/view/screens/auth/vehicle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehiclePage extends StatefulWidget {
  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  TextEditingController fnameController = TextEditingController();

  TextEditingController lnameController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();

  TextEditingController mobileController = new TextEditingController();

  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    authProvider.getUserDetails();
    fnameController.text =
        authProvider.user!.firstName.toString();
    lnameController.text =
        authProvider.user!.lastName.toString();
    mobileController.text =
        authProvider.user!.mobilenumber.toString();
    emailController.text = authProvider.user!.emailid.toString();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"Vehicle Details"),
      body: SingleChildScrollView(
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
                              end: Alignment.bottomRight)),
                    ),
                  ),
                  ClipPath(
                    clipper: DrawClip(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            ColorResources.PRIMARY_COLOR,
                            Color(0xff91c5fc)
                          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                            /*image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/1.jpg')*/
                          ),
                          child: Icon(Icons.account_circle_outlined),
                        )),
                  ),
                  Positioned(
                    top: 125,
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Container(
                            width: 30.0,
                            height: 30.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[500],
                            ),
                            child: Icon(Icons.add)),
                      ),
                    ),
                  ),
                ],
              ),
              RegistrationTextFeild(
                controller: fnameController,
                hintText: "First Name",
                textInputType: TextInputType.text,
                iconData: Icons.person,
              ),
              RegistrationTextFeild(
                controller: lnameController,
                hintText: "Last Name",
                textInputType: TextInputType.text,
                iconData: Icons.person,
              ),
              RegistrationTextFeild(
                  controller: mobileController,
                  hintText: "Mobile Number",
                  textInputType: TextInputType.phone,
                  iconData: Icons.phone_android),
              RegistrationTextFeild(
                  controller: emailController,
                  hintText: "Email Id",
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email),
              CustomButton(
                  onTap: () async {

                   /* showDialog(
                        context: context,
                        builder: (_) =>
                        new CupertinoAlertDialog(
                          title: Text(
                            'Are you sure want to update your profile?',
                            style: Style.heading,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                  'yes',
                                  style: Style.okButton),
                              onPressed: () {
                                model
                                    .updateUser(
                                  first_name:
                                  fnameController
                                      .text,
                                  last_name:
                                  lnameController.text,
                                  mobilenumber:mobileController.text,
                                  emailid:
                                  emailController.text,

                                )
                                    .then((value) =>
                                {
                                  showAnimatedDialog(
                                      context,
                                      MyDialog(
                                        icon: Icons.check,
                                        title:
                                        'Edit Profile',
                                        description:
                                        'Your Profile Updated successfully',
                                        isFailed: false,
                                      ),
                                      dismissible: false,
                                      isFlip: false),
                                }
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                  'no',
                                  style:
                                  Style.cancelButton),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
*/


                  },
                  buttonText: 'Save',isEnable: true,),

            ],
          ),
        ),
      ),
    );
  }

  bool _isObscure = true;

  Widget input(String hint, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: TextFormField(
          obscureText: pass ? _isObscure : false,
          //obscuringCharacter: pass? '*' : '',
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              prefixIcon: pass
                  ? Icon(
                Icons.lock_outline,
                color: Colors.grey,
              )
                  : Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
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
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

