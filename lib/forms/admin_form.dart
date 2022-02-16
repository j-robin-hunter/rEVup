//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/license.dart';
import 'package:revup/services/environment_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/chips_formfield.dart';
import 'package:revup/widgets/color_picker_dialog.dart';
import 'package:revup/widgets/error_dialog.dart';
import 'package:revup/widgets/future_dialog.dart';
import 'package:revup/widgets/padded_text_form_field.dart';
import 'package:revup/widgets/service_dialog.dart';

class AdminForm extends StatefulWidget {
  final License license;
  final Function callback;

  const AdminForm({Key? key, required this.license, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdminFormState();
  }
}

class AdminFormState extends State<AdminForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ChipsInputState> _chipKey = GlobalKey();

  final _selectedColorController = TextEditingController();
  final Map _services = {};

  String? _selectedColorKey;
  bool changed = false;
  Image logo = Image.asset('lib/assets/images/transparent.png');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);
    final Map<String, dynamic> serviceDefinitions = Provider.of<EnvironmentService>(context, listen: false).environment.services;

    if (_services.isEmpty) _buildServices(context, _services);

    //_logoUrl.addListener(() => _logoUrl.value = _logoUrl.value.copyWith(text: _logoUrl.text.toLowerCase()));
    //_administrators.addListener(() => _administrators.value = _administrators.value.copyWith(text: _administrators.text.toLowerCase()));

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        onChanged: () {
          //setState(() => changed = true);
          widget.callback('changed');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text('License holder: ${widget.license.licensee}'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text('Licensed from: ${widget.license.created}'),
            ),
            ChipsInput(
              key: _chipKey,
              width: MediaQuery.of(context).size.width,
              enabled: true,
              maxChips: 5,
              separator: '\n',
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Administrators',
                hintText: 'Administrator emails',
                //floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
              ),
              initialTags: const [],
              chipTextValidator: (String value) {
                value.contains('!');
                return -1;
              },
              chipBuilder: (context, state, String tag) {
                return InputChip(
                  labelPadding: const EdgeInsets.only(left: 8.0, right: 3),
                  key: ObjectKey(tag),
                  label: Text(
                    "# " + tag.toString(),
                    textAlign: TextAlign.center,
                  ),
                  onDeleted: () => state.deleteChip(tag),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
            ),
            const SizedBox(height: 8.0),
            _branding(context, _licenseService),
            const SizedBox(height: 5.0),
            ..._servicesRows(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  //const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: ElevatedButton(
                        child: const Text('OK'),
                        onPressed: () {
                          _saveAdmin(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildServices(BuildContext context, Map services) {
    final Map<String, dynamic> serviceDefinitions = Provider.of<EnvironmentService>(context, listen: false).environment.services;

    for (var serviceType in serviceDefinitions.entries) {
      String type = serviceType.key;
      List<String> serviceSelection = [];
      Map definition = {};
      for (var service in serviceType.value) {
        for (var entry in service.entries) {
          for (var fields in service[entry.key].values) {
            Map content = {};
            (fields as Map).forEach((key, value) {
              TextEditingController controller = TextEditingController();
              content[key] = {
                'controller': controller,
                'widget': {
                  'key': key,
                  'value': value,
                }
              };
            });
            serviceSelection.add(entry.key);
            definition[entry.key] = {
              'dialogContent': content, //entry.value,
              'data': 'data',
            };
          }
        }
      }
      services[type] = {
        'controller': TextEditingController(),
        'adminRow': Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('$type Service'),
                ),
                items: serviceSelection
                    .map(
                      (item) => DropdownMenuItem<String>(
                        child: Text(
                          item,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                        ),
                        value: item,
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  services[type]['controller']?.text = value ?? '';
                },
              ),
            ),
            SizedBox(
              width: 120.0,
              child: TextButton(
                onPressed: () {
                  String namedService = services[type]['controller']!.text;
                  if (namedService.isEmpty) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => const ErrorDialog(
                        error: 'Please select a service',
                      ),
                    );
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ServiceDialog(
                        namedService: namedService,
                        content: services[type]['service'],
                      ),
                    ).then((value) {
                      print('do config');
                    });
                  }
                },
                child: const Text('Configure', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        'service': definition,
      };
    }
  }

  List<Widget> _servicesRows() {
    List<Widget> rows = [];
    for (var key in _services.keys) {
      rows.add(_services[key]['adminRow']);
    }
    return rows;
  }

  Widget _branding(BuildContext context, LicenseService licenseService) {
    String _theme = licenseService.license.branding.theme;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent, //Theme.of(context).highlightColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _imagePicker(context, 'Company\nLogo', logo),
                      _imagePicker(context, 'Background\nimage', logo),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        const Text('Theme:'),
                        Radio<String?>(
                          value: 'light',
                          groupValue: _theme,
                          onChanged: (String? value) {
                            licenseService.setTheme(value!);
                          },
                        ),
                        const Text('Light'),
                        Radio<String?>(
                          value: 'dark',
                          groupValue: _theme,
                          onChanged: (String? value) {
                            licenseService.setTheme(value!);
                          },
                        ),
                        const Text('Dark'),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            label: Text('Colours'),
                          ),
                          items: licenseService.license.branding.colors
                              .map((String item) => DropdownMenuItem<String>(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
                                          child: Container(
                                            width: 15.0,
                                            height: 15.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: licenseService.license.branding.brandColors[item] ?? Colors.transparent,
                                              border: Border.all(
                                                color: licenseService.license.branding.brandColors[item] ?? Theme.of(context).highlightColor,
                                                width: 3.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          item,
                                          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                                        )
                                      ],
                                    ),
                                    value: item,
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            Color color = licenseService.license.branding.brandColors[value] ?? Colors.transparent;
                            _selectedColorKey = value;
                            _selectedColorController.text = color.value.toString();
                            //setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: 120.0,
                        child: TextButton(
                          onPressed: () {
                            if (_selectedColorKey != null) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => ColorPickerDialog(
                                  hexColorController: _selectedColorController,
                                ),
                              ).then((action) {
                                if (action == 'delete') {
                                  licenseService.deleteThemeColor(_selectedColorKey!);
                                } else if (action == 'set') {
                                  licenseService.setThemeColor(_selectedColorKey!, Color(int.parse(_selectedColorController.text)));
                                }
                              });
                            } else {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => const ErrorDialog(
                                  error: 'Please select a color',
                                ),
                              );
                            }
                          },
                          child: const Text('Set Color', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 4.0,
          left: 6.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            color: Theme.of(context).canvasColor,
            child: Text(
              'Theme Branding',
              style: TextStyle(
                fontSize: Theme.of(context).inputDecorationTheme.labelStyle?.fontSize ?? 12.0,
                color: Colors.transparent, //Theme.of(context).inputDecorationTheme.labelStyle?.color ?? Colors.black45,
                backgroundColor: Theme.of(context).canvasColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePicker(BuildContext context, String label, Image image) {
    List<Widget> list = [
      Text(
        label,
        textAlign: TextAlign.center,
      ),
      const SizedBox(width: 8.0),
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Image? _image = await pickImage(ImageSource.gallery);
              if (_image != null) {
                //setState(() => image = _image);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).highlightColor,
                  width: 1,
                ),
                image: DecorationImage(
                  image: logo.image,
                  fit: BoxFit.contain,
                ),
              ),
              height: 80.0,
              width: 120.0,
            ),
          ),
          const Text(
            'Click to replace',
            style: TextStyle(
              fontSize: 10.0,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    ];
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: list);
  }

  Future<Image?> pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return null;
    return Image.memory(await image.readAsBytes());
  }

  Widget _colorPicker(String label, TextEditingController controller, double width, int cols) {
    List<Widget> list = [
      SizedBox(
        width: width - 76,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: cols > 1 ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(label),
        ),
      ),
      const SizedBox(width: 12.0),
      GestureDetector(
        onTap: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ColorPickerDialog(
                hexColorController: controller,
              );
            },
          );
          //setState(() => {});
        },
        child: Container(
          decoration: BoxDecoration(
            color: controller.text.isEmpty ? Colors.transparent : Color(int.parse(controller.text)),
            border: Border.all(
              color: Theme.of(context).highlightColor,
              width: 1,
            ),
          ),
          height: 30.0,
          width: 60.0,
        ),
      ),
    ];
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: cols > 1 ? list : List.from(list.reversed),
      ),
    );
  }

  void _saveAdmin(BuildContext context) {
    final LicenseService _licenceService = Provider.of<LicenseService>(context, listen: false);
    _formKey.currentState!.save();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FutureDialog(
          future: Future.wait([
            _licenceService.saveLicense(),
            Future.delayed(const Duration(seconds: 1), () => 0), // to allow dialog to be seen
          ]),
          waitingString: 'Saving admin data ...',
          hasDataActions: const <Widget>[],
          hasErrorActions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      widget.callback('done');
      //setState(() => changed = false);
    }); // leave settings if save is OK
  }
}
