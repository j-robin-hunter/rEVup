//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/widgets/multiselect_dialog.dart';

class MultiselectFormField extends FormField<dynamic> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final List? dataSource;
  final String? textField;
  final String? valueField;
  final Function? change;
  final Function? open;
  final Function? close;
  final Widget? leading;
  final Widget? trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? chipLabelStyle;
  final Color? chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final bool isEnabled;

  MultiselectFormField({
    Key? key,
    FormFieldSetter<dynamic>? onSaved,
    FormFieldValidator<dynamic>? validator,
    dynamic initialValue,
    AutovalidateMode autovalidate = AutovalidateMode.disabled,
    this.title = const Text('Title'),
    this.hintWidget = const Text('Tap to select one or more'),
    this.required = false,
    this.errorText = 'Please select one or more options',
    this.leading,
    this.dataSource,
    this.textField,
    this.valueField,
    this.change,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.trailing,
    this.chipLabelStyle,
    this.isEnabled = true,
    this.chipBackGroundColor,
    this.dialogTextStyle = const TextStyle(),
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            List<Widget> _buildSelectedOptions(state) {
              List<Widget> selectedOptions = [];
              if (state.value != null) {
                state.value.forEach((item) {
                  var existingItem = dataSource!.singleWhere(((itm) => itm[valueField] == item), orElse: () => null);
                  selectedOptions.add(
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      child: Chip(
                        labelStyle: chipLabelStyle,
                        backgroundColor: chipBackGroundColor,
                        label: Text(
                          existingItem[textField],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                });
              }
              return selectedOptions;
            }

            return Theme(
              data: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 2,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 2,
                    ),
                  ),
                ),
                errorColor: Theme.of(state.context).errorColor,
              ),
              child: InkWell(
                onTap: !isEnabled
                    ? null
                    : () async {
                        List? initialSelected = state.value;
                        initialSelected ??= [];

                        final items = <MultiSelectDialogItem<dynamic>>[];
                        for (var item in dataSource!) {
                          items.add(MultiSelectDialogItem(item[valueField], item[textField]));
                        }

                        List? selectedValues = await showDialog<List>(
                          barrierDismissible: false,
                          context: state.context,
                          builder: (BuildContext context) {
                            return MultiSelectDialog(
                              title: title,
                              okButtonLabel: okButtonLabel,
                              cancelButtonLabel: cancelButtonLabel,
                              items: items,
                              initialSelectedValues: initialSelected,
                              labelStyle: dialogTextStyle,
                              dialogShapeBorder: dialogShapeBorder,
                              checkBoxActiveColor: checkBoxActiveColor,
                              checkBoxCheckColor: checkBoxCheckColor,
                            );
                          },
                        );

                        if (selectedValues != null) {
                          state.didChange(selectedValues);
                          state.save();
                        }
                      },
                child: InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    filled: true,
                    errorText: state.hasError ? state.errorText : null,
                    errorMaxLines: 4,
                    fillColor: Theme.of(state.context).canvasColor,
                  ),
                  isEmpty: state.value == null || state.value == '',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: title,
                            ),
                            required
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5, right: 5),
                                    child: Text(
                                      ' *',
                                      style: TextStyle(
                                        color: Theme.of(state.context).errorColor,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  )
                                : Container(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black87,
                              size: 25.0,
                            ),
                          ],
                        ),
                      ),
                      state.value != null && state.value.length > 0
                          ? Wrap(
                              spacing: 8.0,
                              runSpacing: 0.0,
                              children: _buildSelectedOptions(state),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: hintWidget,
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        );
}
