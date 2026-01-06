import 'dart:io';

import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showRateUsSheet(BuildContext context) {
  int selectedStars = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top indicator
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Rate CarCheks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// DYNAMIC FEEDBACK TEXT
                Text(
                  selectedStars == 0
                      ? "Tap a star to rate your experience"
                      : selectedStars <= 2
                      ? "We're sorry! Tell us how we can improve."
                      : selectedStars == 3
                      ? "Thanks! We appreciate your feedback."
                      : selectedStars == 4
                      ? "Great! We're glad you liked our service."
                      : "Awesome! Thanks for supporting CarCheks!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),

                /// ⭐ INTERACTIVE STAR RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final isSelected = index < selectedStars;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStars = index + 1;
                        });
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.3 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: isSelected
                              ? Colors.amber.shade700
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 25),

                /// ⭐ PLAY STORE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String url;

                      if (Platform.isAndroid) {
                        url = AppConstants.playStoreUrl;
                      } else if (Platform.isIOS) {
                        url = AppConstants.appStoreUrl;
                      } else {
                        // fallback (web / desktop)
                        url = AppConstants.playStoreUrl;
                      }

                      final Uri uri = Uri.parse(url);

                      if (!await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch $url';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      Platform.isIOS ? "Rate on App Store" : "Rate on Play Store",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 15),
              ],
            ),
          );
        },
      );
    },
  );
}
