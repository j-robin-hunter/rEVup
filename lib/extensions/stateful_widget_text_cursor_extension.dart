//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:async';

import 'package:flutter/material.dart';

class TextCursor extends StatefulWidget {
  const TextCursor({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.resumed = false,
    this.cursorColor = Colors.blue,
  }) : super(key: key);

  final Duration duration;
  final bool resumed;
  final Color cursorColor;

  @override
  _TextCursorState createState() => _TextCursorState();
}

class _TextCursorState extends State<TextCursor> with SingleTickerProviderStateMixin {
  bool _displayed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, _onTimer);
  }

  void _onTimer(Timer timer) {
    setState(() => _displayed = !_displayed);
  }

  @override
  void dispose() {
    const TextField();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Opacity(
        opacity: _displayed && widget.resumed ? 1.0 : 0.0,
        child: Container(
          width: 2.0,
          color: widget.cursorColor,
        ),
      ),
    );
  }
}