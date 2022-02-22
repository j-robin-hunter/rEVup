//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/extensions/string_casing_extension.dart';
import 'package:revup/services/cms_service.dart';
import 'package:revup/services/firebase_storage_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/image_uploader.dart';
import 'package:revup/widgets/image_wrapper.dart';
import 'package:revup/widgets/multiselect_formfield.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

enum WhomType { individual, business }

class QuoteForm extends StatefulWidget {
  const QuoteForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuoteFormState();
  }
}

class QuoteFormState extends State<QuoteForm> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _companyName = TextEditingController();
  final _streetAddressOne = TextEditingController();
  final _streetAddressTwo = TextEditingController();
  final _city = TextEditingController();
  final _county = TextEditingController();
  final _postcode = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final Map<String, List<XFile>> _allImages = {};

  bool _termsChecked = false;
  String _title = 'Mr';
  int _currentStep = 0;
  bool _isCompleted = false;
  double _screenWidth = 0;
  List _productsAndServices = [];
  WhomType? _whomType = WhomType.individual;
  CmsService? _cmsService;

  @override
  void initState() {
    super.initState();
    _firstName.addListener(() => _firstName.value = _firstName.value.copyWith(text: _firstName.text.toLowerCase().toTitleCase()));
    _lastName.addListener(() => _lastName.value = _lastName.value.copyWith(text: _lastName.text.toLowerCase().toTitleCase()));
    _streetAddressOne
        .addListener(() => _streetAddressOne.value = _streetAddressOne.value.copyWith(text: _streetAddressOne.text.toLowerCase().toTitleCase()));
    _streetAddressTwo
        .addListener(() => _streetAddressTwo.value = _streetAddressTwo.value.copyWith(text: _streetAddressTwo.text.toLowerCase().toTitleCase()));
    _city.addListener(() => _city.value = _city.value.copyWith(text: _city.text.toLowerCase().toTitleCase()));
    _county.addListener(() => _county.value = _county.value.copyWith(text: _county.text.toLowerCase().toTitleCase()));
    _postcode.addListener(() => _postcode.value = _postcode.value.copyWith(text: _postcode.text.toUpperCase()));
    _phone.addListener(() => _phone.value = _phone.value.copyWith(text: _phone.text.replaceAll(RegExp(r'[^+(\) \d]'), '')));
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _companyName.dispose();
    _streetAddressOne.dispose();
    _streetAddressTwo.dispose();
    _city.dispose();
    _county.dispose();
    _postcode.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _cmsService = Provider.of<LicenseService>(context).cmsService;

    return _isCompleted
        ? const Text('all done now')
        : Center(
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 400,
                maxWidth: 1200,
                maxHeight: 600.0,
              ),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Stepper(
                type: MediaQuery.of(context).size.width > 600 ? StepperType.horizontal : StepperType.vertical,
                steps: getSteps(),
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_formKeys[_currentStep].currentState!.validate()) {
                    final isLastStep = _currentStep == getSteps().length - 1;
                    if (isLastStep) {
                      setState(() => _isCompleted = true);
                      _allImages.forEach((key, images) {
                        for (var image in images) {
                          FirebaseStorageService.uploadXFileImage('enquiry', _email.text, image);
                        }
                      });
                      /*
                  firebaseFirestoreService.createEnquiry({
                    'name': {
                      'title': _title,
                      'firstName': _firstName.text,
                      'lastName': _lastName.text,
                    },
                    'email': _email.text,
                    'address': {
                      'streetAddressOne': _streetAddressOne.text,
                      'streetAddressTwo': _streetAddressTwo.text,
                      'city': _city.text,
                      'county': _county.text,
                      'postcode': _postcode.text,
                      'country': 'United Kingdom',
                    },
                    'phone': _phone.text,
                  });

                   */
                    } else {
                      setState(() => _currentStep += 1);
                    }
                  }
                },
                onStepCancel: _currentStep == 0 ? null : () => setState(() => _currentStep -= 1),
                onStepTapped: (step) {
                  if (_formKeys[_currentStep].currentState!.validate()) {
                    setState(() => _currentStep = step);
                  }
                },
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  final isLastStep = _currentStep == getSteps().length - 1;
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        if (_currentStep != 0)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(isLastStep ? 'Confirm' : 'Next'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text('Data Privacy'),
          content: Form(
            key: _formKeys[0],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _forWhomField,
                const SizedBox(height: 10),
                _solutions,
                const SizedBox(height: 10),
                _privacyStatement,
                //ContentfulRichText(cmsContent['form 3']!.test).documentToWidgetTree
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Your Details'),
          content: Form(
            key: _formKeys[1],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 43,
                      child: _titleField,
                    ),
                    Expanded(
                      child: PaddedTextFormField(
                        labelText: 'First Name',
                        hintText: 'First name',
                        controller: _firstName,
                        validator: Validators.validateNotEmpty,
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 0.0, 8.0),
                      ),
                    ),
                  ],
                ),
                PaddedTextFormField(
                  labelText: 'Last Name',
                  hintText: 'Last name',
                  controller: _lastName,
                  validator: Validators.validateNotEmpty,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 30.0),
                ),
                if (_whomType == WhomType.business)
                  PaddedTextFormField(
                    labelText: 'Company Name',
                    controller: _companyName,
                    validator: Validators.validateNotEmpty,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                PaddedTextFormField(
                  labelText: 'Address',
                  hintText: 'Address',
                  controller: _streetAddressOne,
                  validator: Validators.validateNotEmpty,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                ),
                PaddedTextFormField(
                  controller: _streetAddressTwo,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                ),
                PaddedTextFormField(
                  labelText: 'City',
                  hintText: 'City',
                  controller: _city,
                  validator: Validators.validateNotEmpty,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                ),
                PaddedTextFormField(
                  labelText: 'County',
                  hintText: 'County',
                  controller: _county,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                ),
                PaddedTextFormField(
                  labelText: 'Postcode',
                  hintText: 'Postcode',
                  controller: _postcode,
                  validator: Validators.validatePostcode,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 30.0),
                ),
                PaddedTextFormField(
                  labelText: 'Phone',
                  hintText: 'Phone',
                  controller: _phone,
                  validator: Validators.validatePhone,
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                ),
                PaddedTextFormField(
                  labelText: 'EMail',
                  hintText: 'EMail',
                  controller: _email,
                  validator: Validators.validateEmail,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text('Installation Details'),
          content: Form(
            key: _formKeys[2],
            child: Column(
              children: <Widget>[
                const Text('We need to get some details so we can work out a route for the installation'),
                const SizedBox(height: 30),
                //if (_productsAndServices.contains('Electric Vehicle Charging')) _imagesField('form 1', 2, height: _screenWidth > 600 ? 80 : 75),
                _imagesField('fuseboard', 1, height: _screenWidth > 600 ? 80 : 75, maxImages: 2),
                //_imagesField('form 3', 1, height: _screenWidth > 600 ? 80 : 75),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 3,
          title: const Text('Summary'),
          content: Form(
            key: _formKeys[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _summary,
              ],
            ),
          ),
        ),
      ];

  //
  // WIDGETS
  //
  Widget get _forWhomField {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: const Text('I would like to request a quote'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio<WhomType>(
                    value: WhomType.individual,
                    groupValue: _whomType,
                    onChanged: (WhomType? value) {
                      setState(() {
                        _whomType = value;
                      });
                    },
                  ),
                  const Text('for myself')
                ],
              ),
              Row(
                children: <Widget>[
                  Radio<WhomType>(
                    value: WhomType.business,
                    groupValue: _whomType,
                    onChanged: (WhomType? value) {
                      setState(() {
                        _whomType = value;
                      });
                    },
                  ),
                  const Text('for a business'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _solutions {
    return MultiselectFormField(
      title: const Text('I am interested in'),
      hintWidget: const Text(
        'Please tap to select one or more options',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black54,
        ),
      ),
      autovalidate: AutovalidateMode.disabled,
      //chipBackGroundColor: const Color(0xff84c1c1),
      //chipLabelStyle: const TextStyle(color: Colors.white),
      //checkBoxActiveColor: const Color(0xff84c1c1),
      //checkBoxCheckColor: Colors.white,
      dialogShapeBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
      dialogTextStyle: const TextStyle(fontSize: 14),
      validator: (value) {
        if (value == null || value.length == 0) {
          return 'Please select one or more product or service';
        }
        return null;
      },
      dataSource: const [
        {
          "display": "Electric Vehicle Charging",
          "value": "Electric Vehicle Charging",
        },
        {
          "display": "EV Chargepoint Operator Services",
          "value": "EV Chargepoint Operator Services",
        },
        {
          "display": "Storage Batteries",
          "value": "Storage Batteries",
        },
        {
          "display": "Solar PV",
          "value": "Solar PV",
        },
        {
          "display": "Energy Management",
          "value": "Energy Management",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      initialValue: _productsAndServices,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          _productsAndServices = value;
        });
      },
    );
  }

  Widget get _privacyStatement {
    return FormField<bool>(
      initialValue: _termsChecked,
      builder: (FormFieldState<bool> state) {
        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12.0,
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    border: Border.all(
                      color: Colors.black54,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _cmsService?.getCmsContent('privacy')?.textContent,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: state.value,
                    onChanged: (bool? value) => setState(() {
                      _termsChecked = value!;
                      state.didChange(value);
                    }),
                  ),
                  const Flexible(
                    child: Text('I agree to the above conditions for the storing and processing of my personal data.'),
                  ),
                ],
              ),
              state.errorText == null ? const Text('') : Text(state.errorText!, style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12)),
            ],
          ),
        );
      },
      validator: (val) => _validateTerms(_termsChecked),
    );
  }

  Widget get _titleField {
    final _titles = ['Mr', 'Mrs', 'Ms', 'Miss', 'Dr', 'Prof', 'Rev'];

    return DropdownButtonFormField(
      items: _titles
          .map((String item) => DropdownMenuItem<String>(
              child: Text(
                item,
                style: const TextStyle(color: Colors.black54),
              ),
              value: item))
          .toList(),
      onChanged: (value) {
        setState(() {
          _title = value as String;
        });
      },
      value: _title,
    );
  }

  Widget get _summary {
    return Column(
      children: <Widget>[
        _summaryProductAndServices(),
        const SizedBox(height: 10),
        _summaryText('Name:', '$_title ${_firstName.text} ${_lastName.text}'),
        const SizedBox(height: 10),
        if (_whomType == WhomType.business) _summaryText('Company Name:', _companyName.text),
        const SizedBox(height: 10),
        _summaryText('Address:', _streetAddressOne.text),
        if (_streetAddressTwo.text.isNotEmpty) _summaryText('', _streetAddressTwo.text),
        _summaryText('', _city.text),
        _summaryText('', _county.text),
        _summaryText('', _postcode.text),
        const SizedBox(height: 10),
        _summaryText('Phone:', _phone.text),
        _summaryText('Email:', _email.text),
        _summaryImage('Fuse box images:', 'form 1'),
        _summaryImage('Service fuse:', 'form 2'),
        _summaryImage('Other images:', 'form 3'),
      ],
    );
  }

  //
  // Methods
  //
  Widget _imagesField(String name, int minImages, {int maxImages = 0, double height = 150}) {
    if (!_allImages.containsKey(name)) {
      _allImages[name] = [];
    }
    return FormField<bool>(
      builder: (FormFieldState<bool> state) {
        return Column(
          children: <Widget>[
            ImageUploader(
              images: _allImages[name],
              contentName: name,
              height: height,
              columns: 4,
              maxImages: maxImages,
            ),
            state.errorText == null ? const Text('') : Text(state.errorText!, style: const TextStyle(color: Color(0xFFe53935), fontSize: 12)),
          ],
        );
      },
      validator: (val) => _validateImages(name, minImages),
    );
  }

  Widget _summaryProductAndServices() {
    var loc = _productsAndServices.join('\n');
    return _summaryText('Enquiry for:', loc, maxLines: _productsAndServices.length);
  }

  Widget _summaryText(String label, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 250,
          child: Text(label),
        ),
        Text(text), //maxLines: maxLines),
      ],
    );
  }

  Widget _summaryImage(String label, String name) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 250,
          child: Text(label),
        ),
        Expanded(
          child: ImageWrapper(
            images: _allImages[name],
            columns: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            height: 60,
            alignment: WrapAlignment.start,
          ),
        ),
      ],
    );
  }

  //
  // VALIDATORS
  //
  String? _validateTerms(value) {
    if (!value) {
      return 'Please accept our privacy policy';
    }
    return null;
  }

  String? _validateImages(String name, int minLength) {
    List<String> names = _allImages[name]!.map((image) => image.name).toList();
    if (names.length < minLength) {
      return 'Please add additional images - at least $minLength required';
    } else {
      // Check for duplicates images within this form field (only on image name)
      bool dup = false;
      if (names.toSet().length != names.length) {
        dup = true;
      }
      // Check for duplicate images across form fields (only on image name)
      _allImages.forEach((key, allImages) {
        if (key != name) {
          for (var image in allImages) {
            if (names.contains(image.name)) {
              dup = true;
              return;
            }
          }
        }
      });
      if (dup) {
        return 'Please remove duplicate images';
      }
    }
    return null;
  }
}
