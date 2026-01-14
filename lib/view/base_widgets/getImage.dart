import 'package:flutter/material.dart';

getImage(String src) {
  return Hero(
    tag: 'profile',
    child: src == ""
        ? Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/my_profile.png'),
              ),
            ),
          )
        : Container(
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(src),
              ),
            ),
          ),
  );
}
