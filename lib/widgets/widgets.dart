import 'package:flutter/material.dart';
import 'package:todo_app/sixeConfig.dart';

class cWidgets {
  static InputDecoration inputDecoration(
          {required String? lableText, required String? hintText}) =>
      InputDecoration(
        labelText: lableText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConfig.smallSize),
        ),
      );

  static SizedBox sizedBox({double? height, double? width}) => SizedBox(
        height: height,
        width: width,
      );

  static TextInputType text() => TextInputType.text;

  static ElevatedButton elevatedButton(
      {required VoidCallback press, String? text}) {
    return ElevatedButton(
      onPressed: press,
      child: Text("$text"),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeConfig.mediumSize*2)
        )
      ),
    );
  }
}
