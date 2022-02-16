//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends Dialog {
  final TextEditingController hexColorController;
  final double width;
  final double height;

  const ColorPickerDialog({
    Key? key,
    required this.hexColorController,
    this.width = 300.0,
    this.height = 430.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color pickerColor = hexColorController.text.isEmpty ? Colors.black : Color(int.parse(hexColorController.text));
    return Dialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ColorPicker(
              pickerColor: pickerColor,
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              displayThumbColor: true,
              paletteType: PaletteType.rgbWithBlue,
              onColorChanged: (Color value) => hexColorController.text = value.value.toString(),
              hexInputController: hexColorController,
              hexInputBar: true,
              portraitOnly: true,
              enableAlpha: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, 'cancel');
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      Navigator.pop(context, 'delete');
                    },
                  ),
                  TextButton(
                    child: const Text('Set'),
                    onPressed: () {
                      Navigator.pop(context, 'set');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
