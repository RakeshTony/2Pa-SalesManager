import 'package:flutter/material.dart';
import '../Theme/colors.dart';
import 'app_icons.dart';

var decorationBackground = BoxDecoration(
  color: kMainColor,
  image: DecorationImage(
    image: AssetImage(SPLASH),
    fit: BoxFit.cover,
  ),
);