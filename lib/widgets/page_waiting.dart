//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';

class PageWaiting extends StatelessWidget {
  final String? message;

  const PageWaiting({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(),
          ),
          message != null ? Padding(padding: const EdgeInsets.only(top: 10.0), child: Text(message!)) : const SizedBox.shrink()
        ],
      ),
    );
  }
}
