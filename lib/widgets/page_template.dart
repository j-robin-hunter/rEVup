import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final Widget body;
  final Widget? action;
  final bool topImage;
  final Widget? logo;
  final Color? topColor;
  final Color? bottomColor;
  final String? bottomText;

  const PageTemplate({
    Key? key,
    this.action,
    required this.body,
    this.topImage = true,
    this.logo,
    this.topColor,
    this.bottomColor,
    this.bottomText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    : const DecorationImage(
                        image: AssetImage('lib/assets/images/earth.png'),
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
            //if (logo != null)
            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 86.0,
                  child: logo ?? Image.asset('lib/assets/images/logo-rev-230x132.png'),
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
    );
  }

  Widget _back(BuildContext context) {
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  Widget _copyright(BuildContext context, Color? bottomColor, String? bottomText) {
    return Container(
      width: double.infinity,
      height: 40.0,
      color: bottomColor ?? Theme.of(context).bottomAppBarColor,
      child: Center(
        child: Text(
          bottomText ?? 'Copyright © ${DateTime.now().year} Roma Technology Limited. All rights reserved.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
