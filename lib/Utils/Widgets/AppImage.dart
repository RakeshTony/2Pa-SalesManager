import 'dart:io';


import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';

class AppImage extends StatelessWidget {
  String path;
  double size;
  String defaultImage;
  Color borderColor;
  Color backgroundColor;
  Color textColor;
  double borderWidth;
  BoxShape shape;
  bool isUrl;
  bool isFile;

  AppImage(
    this.path,
    this.size, {
    this.defaultImage = DEFAULT_OPERATOR,
    this.borderColor = kTransparentColor,
    this.backgroundColor = kTransparentColor,
    this.textColor = kWhiteColor,
    this.borderWidth = 1,
    this.shape = BoxShape.circle,
    this.isUrl = true,
    this.isFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor,
        border: Border.all(
          width: borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: isFile
            ? Image.file(
                File(path),
                height: size,
                width: size,
              )
            : isUrl
                ? FadeInImage(
                    image: NetworkImage(path),
                    width: size,
                    height: size,
                    placeholder: AssetImage(defaultImage),
                    imageErrorBuilder: ((context, error, stackTrace) {
                      return Image.asset(defaultImage);
                    }),
                  )
                : Center(
                    child: Text(
                      path.toUpperCase(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: RFontWeight.BOLD,
                      ),
                    ),
                  ),
      ),
    );
  }
}
