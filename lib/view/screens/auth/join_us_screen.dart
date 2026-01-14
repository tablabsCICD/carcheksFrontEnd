import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class JoinUsScreen extends StatefulWidget {
  const JoinUsScreen({super.key});

  @override
  _JoinUsScreenState createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {
  bool isSelectedGarageOwner = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: DrawClip2(),
              child: Container(
                width: size.width,
                height: size.height * 0.7,
                decoration: const BoxDecoration(
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
                height: size.height * 0.7,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorResources.PRIMARY_COLOR, Color(0xff91c5fc)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  Text(
                    "Join Us..",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Choose how you want to continue",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 100),

                  /// CUSTOMER CARD
                  _SelectionCard(
                    title: "Customer",
                    icon: Icons.person_outline,
                    isSelected: !isSelectedGarageOwner,
                    activeColor: Colors.green,
                    onTap: () {
                      setState(() {
                        isSelectedGarageOwner = !isSelectedGarageOwner;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// BUSINESS CARD
                  _SelectionCard(
                    title: "Business Owner",
                    icon: Icons.storefront_outlined,
                    isSelected: isSelectedGarageOwner,
                    activeColor: Colors.green,
                    onTap: () {
                      setState(() {
                        isSelectedGarageOwner = !isSelectedGarageOwner;
                      });
                    },
                  ),

                  const Spacer(),

                  Center(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.register,
                          arguments: {isSelectedGarageOwner},
                        );
                      },
                      buttonText: "Continue",
                      isEnable: true,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Reusable Selection Card (UI only)
/// ---------------------------------------------------------------------------
class _SelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? activeColor : Colors.grey.shade300,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: isSelected ? activeColor : Colors.black,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? activeColor : Colors.black,
                  ),
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 26,
                color: isSelected ? activeColor : Colors.grey,
              ),
            ],
          ),
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
