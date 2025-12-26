import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../provider/auth_provider.dart';
import '../../../route/app_routes.dart';
import '../../../util/color-resource.dart';
import '../../../util/sharepreferences.dart';
import '../../base_widgets/custom_button.dart';
import '../../base_widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isCustomerLogin = true;
  bool _isObscure = true;

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      /// BACKGROUND 1
                      ClipPath(
                        clipper: DrawClip2(),
                        child: Container(
                          height: size.height * 0.55,
                          width: size.width,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffa58fd2), Color(0xffddc3fc)],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                        ),
                      ),

                      /// BACKGROUND 2
                      ClipPath(
                        clipper: DrawClip(),
                        child: Container(
                          height: size.height * 0.55,
                          width: size.width,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorResources.PRIMARY_COLOR,
                                Color(0xff91c5fc)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),

                      /// CONTENT
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// LOGIN TYPE TABS
                            _buildLoginTypeTabs(),

                            const SizedBox(height: 10),

                            /// FORM AREA WITH EXTRA PADDING
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _mobileField(),
                                    const SizedBox(height: 12),
                                    _passwordField(),
                                    const SizedBox(height: 20),

                                    /// LOGIN BUTTON
                                    Container(
                                      width: size.width * 0.7,
                                      child: CustomButton(
                                        buttonText: "Login",isEnable: true,
                                        onTap: () {
                                          if (isCustomerLogin) {
                                            loginUser(model, context);
                                          } else {
                                            loginGarage(model, context);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// SIGN UP SECTION
                  _signUpSection(context),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔵 Login Type Tabs
  Widget _buildLoginTypeTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          _tabButton("Customer", isCustomerLogin, () {
            setState(() => isCustomerLogin = true);
          }),
          _tabButton("Garage Owner", !isCustomerLogin, () {
            setState(() => isCustomerLogin = false);
          }),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔵 Mobile Field (Fixed Overflow)
  Widget _mobileField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: mobileController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: Validators.compose([
          Validators.required("Mobile number required"),
          Validators.minLength(10, "Enter valid 10-digit mobile"),
        ]),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_iphone, color: Colors.grey),
          hintText: "Mobile Number",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        ),
      ),
    );
  }

  // 🔵 Password Field
  Widget _passwordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: _isObscure,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey),
            onPressed: () => setState(() => _isObscure = !_isObscure),
          ),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        ),
      ),
    );
  }

  // 🔵 Sign Up Section
  Widget _signUpSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.select_type),
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xff5172b4),
            ),
          ),
        )
      ],
    );
  }

  // 🔵 Customer Login
  void loginUser(AuthProvider model, context) async {
    getLoader(context, true);

    if (_formKey.currentState!.validate()) {
      var result = await model.loginUsingMobileNumber(
        mobileController.text,
        passwordController.text,
      );

      dismissLoader(context);

      if (result["success"] == true) {
        if (result["data"]["garrage_Owner"]) {
          _toast("Please switch to Garage Owner login");
        } else {

          model.setVisitingFlag(true);
          model.setUserId(result["data"]["id"]);

          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.entryScreen, (route) => false);
        }
      } else {
        _toast(result["message"].toString());
      }
    } else {
      dismissLoader(context);
    }
  }

  // 🔵 Garage Owner Login
  void loginGarage(AuthProvider model, context) async {
    getLoader(context, true);

    if (_formKey.currentState!.validate()) {
      var result = await model.loginUsingMobileNumber(
        mobileController.text,
        passwordController.text,
      );

      dismissLoader(context);

      if (result["success"] == true) {
        if (result["data"]["garrage_Owner"]) {
          model.setGarageOwnerVisitingFlag(true);
          model.setUserId(result["data"]["id"]);

          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.entryScreen, (route) => false);
        } else {
          _toast("Please switch to Customer login");
        }
      } else {
        _toast(result["message"].toString());
      }
    } else {
      dismissLoader(context);
    }
  }

  void _toast(String msg) {
    showSimpleNotification(
      Text(msg, style: const TextStyle(color: Colors.white)),
      background: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }
}

//
// CLIPPERS (Reduced Height to Stop Overflow)
//
class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.70);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height * 0.45, size.width, size.height * 0.70);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => true;
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.70);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height * 0.50, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => true;
}