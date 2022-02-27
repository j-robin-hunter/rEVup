//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/services/license_service.dart';

class PageTemplate extends StatelessWidget {
  final Widget body;
  final Widget? action;
  final bool topImage;
  final AlignmentGeometry logoPosition;
  final Color? topColor;
  final Color? bottomColor;
  final String? bottomText;

  const PageTemplate({
    Key? key,
    this.action,
    required this.body,
    this.topImage = true,
    this.logoPosition = Alignment.centerRight,
    this.topColor,
    this.bottomColor,
    this.bottomText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 110.0,
                decoration: BoxDecoration(
                  color: topColor ?? Theme.of(context).appBarTheme.backgroundColor,
                  image: topImage == false
                      ? null
                      : DecorationImage(
                          image: _licenseService.getImage('background')['image'].image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                top: 35.0,
                left: 10.0,
                child: SizedBox(
                  height: 35.0,
                  child: action ?? _back(context),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: logoPosition,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 86.0,
                      child: Provider.of<LicenseService>(context).getImage('logo')['image'],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: body,
              ),
            ),
          ),
          _copyright(context, bottomColor, bottomText),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Widget _copyright(BuildContext context, Color? bottomColor, String? bottomText) {
    Color copyrightColor =
        ThemeData.estimateBrightnessForColor(Theme.of(context).bottomAppBarColor) == Brightness.light ? Colors.black87 : Colors.white;
    return Container(
      width: double.infinity,
      height: 40.0,
      color: bottomColor ?? Theme.of(context).bottomAppBarColor,
      child: Center(
        child: Text(
          bottomText ?? 'Copyright © ${DateTime.now().year} Roma Technology Limited. All rights reserved.',
          style: TextStyle(
            color: copyrightColor,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
