import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../provider/auth_provider.dart';
import '../../../route/app_routes.dart';
import '../../../util/color-resource.dart';
import '../../base_widgets/custom_button.dart';
import '../../base_widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
                          height: size.height * 0.7,
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
                          height: size.height * 0.7,
                          width: size.width,
                          decoration: const BoxDecoration(
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

                      /// CONTENT
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              foregroundImage: AssetImage(
                                "assets/images/carchecks.jpeg",
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 70),

                            /// LOGIN TYPE TABS
                            _buildLoginTypeTabs(),

                            const SizedBox(height: 20),

                            /// FORM AREA WITH EXTRA PADDING
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                        buttonText: "Login",
                                        isEnable: true,
                                        onTap: () {
                                          if (isCustomerLogin) {
                                            loginUser(model, context);
                                          } else {
                                            loginGarage(model, context);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        onPressed: () =>
                                            _showForgotPasswordSheet(context),
                                        child: const Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
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
          _tabButton("Business Owner", !isCustomerLogin, () {
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

  void _showForgotPasswordSheet(BuildContext context) {
    final theme = Theme.of(context);
    final primary = ColorResources.PRIMARY_COLOR;

    final TextEditingController mobileCtrl = TextEditingController();
    final TextEditingController otpCtrl = TextEditingController();

    bool otpSent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bottomSheetHandle(),

                  Text(
                    "Forgot Password",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Verify your mobile number",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// MOBILE
                  _roundedField(
                    controller: mobileCtrl,
                    label: "Mobile Number",
                    icon: Icons.phone,
                    enabled: !otpSent,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),

                  if (otpSent) ...[
                    const SizedBox(height: 16),

                    /// OTP
                    _roundedField(
                      controller: otpCtrl,
                      label: "OTP",
                      icon: Icons.lock,
                      keyboardType: TextInputType.number,
                    ),
                  ],

                  const SizedBox(height: 28),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (!otpSent) {
                          if (mobileCtrl.text.length != 10) {
                            _toast("Enter valid mobile number");
                            return;
                          }

                          /// 🔹 SEND OTP API
                          _toast("OTP sent to mobile");
                          setState(() => otpSent = true);
                        } else {
                          if (otpCtrl.text.isEmpty) {
                            _toast("Enter valid OTP");
                            return;
                          }

                          /// 🔹 VERIFY OTP API
                          Navigator.pop(context);

                          _showResetPasswordSheet(context);
                        }
                      },
                      child: Text(
                        otpSent ? "Verify OTP" : "Send OTP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showResetPasswordSheet(BuildContext context) {
    final theme = Theme.of(context);
    final primary = ColorResources.PRIMARY_COLOR;

    final TextEditingController passCtrl = TextEditingController();
    final TextEditingController confirmCtrl = TextEditingController();

    bool obscure1 = true;
    bool obscure2 = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bottomSheetHandle(),

                  Text(
                    "Reset Password",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// NEW PASSWORD
                  _roundedField(
                    controller: passCtrl,
                    label: "New Password",
                    icon: Icons.password,
                    obscureText: obscure1,
                    suffix: IconButton(
                      icon: Icon(
                        obscure1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => obscure1 = !obscure1),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// CONFIRM PASSWORD
                  _roundedField(
                    controller: confirmCtrl,
                    label: "Confirm Password",
                    icon: Icons.password,
                    obscureText: obscure2,
                    suffix: IconButton(
                      icon: Icon(
                        obscure2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => obscure2 = !obscure2),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// RESET BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (passCtrl.text.length < 6) {
                          _toast("Password must be at least 6 characters");
                          return;
                        }

                        if (passCtrl.text != confirmCtrl.text) {
                          _toast("Passwords do not match");
                          return;
                        }

                        /// 🔹 RESET PASSWORD API
                        Navigator.pop(context);
                        _toast("Password reset successful");
                      },
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomSheetHandle() {
    return Container(
      height: 4,
      width: 50,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _roundedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
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
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => _isObscure = !_isObscure),
          ),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
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
        ),
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
          _toast("Please switch to Business Owner login");
        } else {
          model.setVisitingFlag(true);
          model.setUserId(result["data"]["id"]);

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.entryScreen,
            (route) => false,
          );
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
            context,
            AppRoutes.entryScreen,
            (route) => false,
          );
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
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * 0.8,
    );
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
