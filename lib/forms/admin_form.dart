//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:revup/screens/license_screen.dart';
import 'package:revup/services/environment_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/color_picker_dialog.dart';
import 'package:revup/widgets/error_dialog.dart';
import 'package:revup/widgets/future_dialog.dart';
import 'package:revup/widgets/service_dialog.dart';

class AdminForm extends StatefulWidget {
  final Function callback;

  const AdminForm({Key? key, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdminFormState();
  }
}

class AdminFormState extends State<AdminForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _selectedColorController = TextEditingController();
  final Map _services = {};

  String? _selectedColorKey;
  bool modified = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedColorController.dispose();
    _clearServiceControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    if (_services.isEmpty) _buildServices(context);
    String licensedFrom = _licenseService.created != null ? DateFormat("dd-MM-yyyy").format(_licenseService.created!) : 'Not configured';

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text('License holder: ${_licenseService.licensee}'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text('Licensed from: $licensedFrom'),
            ),
            const SizedBox(height: 8.0),
            _branding(context),
            const SizedBox(height: 5.0),
            ..._servicesRows(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  //const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 36.0,
                      child: ElevatedButton(
                        child: Text(modified ? 'Cancel' : 'Done'),
                        onPressed: () async {
                          if (modified) {
                            _clearServiceControllers();
                            _services.clear();
                            await _licenseService.reLoadLicense();
                            setState(() => modified = false);
                          } else {
                            _setFormDone();
                          }
                        },
                      ),
                    ),
                  ),
                  modified
                      ? Expanded(
                          child: SizedBox(
                            height: 36.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  _saveAdmin(context);
                                  setState(() => modified = false);
                                },
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildServices(BuildContext context) {
    final Map<String, dynamic> _environmentServices = Provider.of<EnvironmentService>(context, listen: false).environment.services;
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    _services.addAll(_environmentServices);
    _environmentServices.forEach((serviceType, serviceTypeMap) {
      String? currentServiceNameValue;
      (serviceTypeMap as Map).forEach((namedService, namedServiceMap) {
        if (namedServiceMap is Map) {
          namedServiceMap.forEach((field, fieldEntry) {
            Map? values = _licenseService.getServiceDefinition(serviceType.toLowerCase());
            if (values != null) {
              if (values.containsKey('serviceName')) {
                currentServiceNameValue = values['serviceName'];
              }
            }
            TextEditingController controller = TextEditingController();
            controller.text = values?[field] ?? '';
            (fieldEntry as Map)['controller'] = controller;
          });
        }
      });
      TextEditingController serviceController = TextEditingController();
      serviceController.text = currentServiceNameValue ?? '';
      _services[serviceType].addAll({
        'controller': serviceController,
        'formKey': GlobalKey<FormState>(),
        'adminRow': Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('$serviceType Service'),
                ),
                value: currentServiceNameValue,
                items: [..._services[serviceType].keys]
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
                  _services[serviceType]['controller']?.text = value ?? '';
                },
              ),
            ),
            SizedBox(
              width: 120.0,
              child: TextButton(
                onPressed: () {
                  String namedService = _services[serviceType]['controller']!.text;
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
                        content: _services[serviceType][namedService],
                      ),
                    ).then((value) {
                      if (value) {
                        _licenseService.setService(serviceType, namedService, _services[serviceType][namedService]);
                        setState(() => modified = true);
                      }
                    });
                  }
                },
                child: const Text('Configure', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        //'service': definition,
      });
    });
  }

  List<Widget> _servicesRows() {
    List<Widget> rows = [];
    for (var key in _services.keys) {
      rows.add(_services[key]['adminRow']);
    }
    return rows;
  }

  Widget _branding(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);
    String _theme = _licenseService.getTheme();

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
                      _imagePicker(context, 'logo'),
                      _imagePicker(context, 'background'),
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
                            _licenseService.setTheme(value!);
                            setState(() => modified = true);
                          },
                        ),
                        const Text('Light'),
                        Radio<String?>(
                          value: 'dark',
                          groupValue: _theme,
                          onChanged: (String? value) {
                            _licenseService.setTheme(value!);
                            setState(() => modified = true);
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
                          items: _licenseService
                              .getColors()
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
                                              color: _licenseService.getThemeColor(item) ?? Colors.transparent,
                                              border: Border.all(
                                                color: _licenseService.getThemeColor(item) ?? Theme.of(context).highlightColor,
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
                            Color color = _licenseService.getThemeColor(value) ?? Colors.transparent;
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
                                  _licenseService.deleteThemeColor(_selectedColorKey!);
                                } else if (action == 'set') {
                                  _licenseService.setThemeColor(_selectedColorKey!, Color(int.parse(_selectedColorController.text)));
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

  Widget _imagePicker(BuildContext context, String name) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);
    Map<String, dynamic> image = _licenseService.getImage(name);

    List<Widget> list = [
      Text(
        image['name'],
        textAlign: TextAlign.center,
      ),
      const SizedBox(width: 8.0),
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Image? _image = await pickImage(ImageSource.gallery);
              if (_image != null) {
                _licenseService.setImage(name, _image);
                setState(() => modified = true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).highlightColor,
                  width: 1,
                ),
                image: DecorationImage(
                  image: image['image'].image,
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
      //setState(() => changed = false);
    }); // leave settings if save is OK
  }

  void _clearServiceControllers() {
    _services.forEach((serviceType, serviceTypeMap) {
      TextEditingController controller = (serviceTypeMap as Map)['controller'];
      try {
        controller.dispose();
      } catch (e) {
        // Do nothing - normally will be called due to disposing already
      }
      serviceTypeMap.forEach((namedService, namedServiceMap) {
        if (namedServiceMap is Map) {
          namedServiceMap.forEach((field, fieldEntry) {
            TextEditingController controller = (fieldEntry as Map)['controller'];
            try {
              controller.dispose();
            } catch (e) {
              // Do nothing - normally will be called due to disposing already
            }
          });
        }
      });
    });
  }

  void _setFormDone() {
    widget.callback(AdminStep.admin);
  }
}
