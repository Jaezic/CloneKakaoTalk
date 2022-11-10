import 'package:flutter/material.dart';

class CommonButton extends Material {
  CommonButton({
    super.key,
    String? title,
    void Function()? onTap,
    super.color = Colors.transparent,
    Widget? child,
    EdgeInsetsGeometry? padding = const EdgeInsets.all(16),
    TextAlign? textAlign,
    TextStyle? textStyle,
    Color? splashColor,
  }) : super(
          child: InkWell(
            splashColor: splashColor,
            onTap: onTap,
            child: title != null
                ? Container(
                    padding: padding,
                    child: Text(
                      title,
                      textAlign: textAlign,
                      style: textStyle,
                    ),
                  )
                : child != null
                    ? Container(padding: padding, child: child)
                    : Container(),
          ),
        );
}
