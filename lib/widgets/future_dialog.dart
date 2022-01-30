//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';

class FutureDialog extends Dialog {
  final Future future;
  final String? waitingTitle;
  final String? waitingString;
  final String? hasDataTitle;
  final String hasDataString;
  final List<Widget> hasDataActions;
  final String? hasErrorTitle;
  final String? hasErrorString;
  final bool appendError;
  final List<Widget> hasErrorActions;
  final double width;
  final double height;

  const FutureDialog({
    Key? key,
    this.waitingTitle,
    this.waitingString,
    required this.future,
    this.hasDataTitle,
    this.hasDataString = 'Done.',
    required this.hasDataActions,
    this.hasErrorTitle,
    this.hasErrorString,
    required this.hasErrorActions,
    this.appendError = false,
    this.width = 400.0,
    this.height = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (hasDataActions.isEmpty) {
                  Navigator.pop(context);
                  return const SizedBox.shrink();
                }
                return _has(hasDataTitle, hasDataString, hasDataActions);
              } else if (snapshot.hasError) {
                String errorString =
                    hasErrorString != null ? hasErrorString! + ' ' + (appendError ? snapshot.error.toString() : '') : snapshot.error.toString();
                return _has(hasErrorTitle, errorString, hasErrorActions);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      waitingString != null
                          ? Padding(padding: const EdgeInsets.only(top: 10.0), child: Text(waitingString!))
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _has(String? title, String text, List<Widget> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null ? Text(title, style: const TextStyle(fontWeight: FontWeight.bold)) : const SizedBox.shrink(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(text.replaceAll(RegExp(r"\[.*\] "), '')),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ],
    );
  }
}
