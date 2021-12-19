import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/cms_content.dart';
import 'package:revup/services/firebase_firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EnquiryForm extends StatefulWidget {
  final String email;

  const EnquiryForm(this.email, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnquiryFormState();
  }
}

class EnquiryFormState extends State<EnquiryForm> {
  final _enquiryFormKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _streetAddressOne = TextEditingController();
  final _streetAddressTwo = TextEditingController();
  final _city = TextEditingController();
  final _county = TextEditingController();
  final _postcode = TextEditingController();
  final _phone = TextEditingController();

  bool _termsChecked = false;
  String _title = 'Mr';
  int _currentStep = 0;
  final List _images = [];
  Map<String, CmsContent> _cmsContent = {};

  @override
  Widget build(BuildContext context) {
    final firebaseFirestoreService = Provider.of<FirebaseFirestoreService>(context);
    _cmsContent = Provider.of<Map<String, CmsContent>>(context);

    _email.text = widget.email;

    return Container(
      margin: const EdgeInsets.all(24),
      child: Form(
        key: _enquiryFormKey,
        child: Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF84c1c1))),
          child: Stepper(
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: _currentStep,
            onStepContinue: () {
              if (_enquiryFormKey.currentState!.validate()) {
                final isLastStep = _currentStep == getSteps().length - 1;
                if (isLastStep) {
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
                } else {
                  setState(() => _currentStep += 1);
                }
              }
            },
            onStepCancel: _currentStep == 0 ? null : () => setState(() => _currentStep -= 1),
            onStepTapped: (step) {
              if (_enquiryFormKey.currentState!.validate()) {
                setState(() => _currentStep = step);
              }
            },
            controlsBuilder: (context, {onStepContinue, onStepCancel}) {
              final isLastStep = _currentStep == getSteps().length - 1;
              return Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: Text(isLastStep ? 'Confirm' : 'Next'),
                        onPressed: onStepContinue,
                      )
                    ),
                    const SizedBox(width: 12),
                    if (_currentStep != 0)
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('Back'),
                          onPressed: onStepCancel,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text('Data Privacy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _privacyStatement,
            ],
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Your Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _nameFields,
              _emailField,
              _streetAddressOneField,
              _streetAddressTwoField,
              _cityField,
              _countyField,
              _postcodeField,
              _phoneField,
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: const Text('Installation Details'),
          content: Column(
            children: <Widget>[
              _imageOne,
            ],
          ),
        ),
      ];

  //
  // WIDGETS
  //

  Widget get _nameFields {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _titleField,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: _firstNameField,
            ),
          ],
        ),
        _lastNameField,
      ],
    );
  }

  Widget get _titleField {
    final _titles = ['Mr', 'Mrs', 'Ms', 'Miss'];

    return DropdownButtonFormField(
      items: _titles.map((String item) => DropdownMenuItem<String>(child: Text(item), value: item)).toList(),
      onChanged: (value) {
        setState(() {
          _title = value as String;
        });
      },
      value: _title,
    );
  }

  Widget get _firstNameField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'First Name',
      ),
      controller: _firstName,
    );
  }

  Widget get _lastNameField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Last Name',
      ),
      controller: _lastName,
    );
  }

  Widget get _emailField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      controller: _email,
    );
  }

  Widget get _streetAddressOneField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Street Address',
      ),
      controller: _streetAddressOne,
    );
  }

  Widget get _streetAddressTwoField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Address Line 2',
      ),
      controller: _streetAddressTwo,
    );
  }

  Widget get _cityField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'City',
      ),
      controller: _city,
    );
  }

  Widget get _countyField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'County',
      ),
      controller: _county,
    );
  }

  Widget get _postcodeField {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Postcode',
      ),
      controller: _postcode,
    );
  }

  Widget get _phoneField {
    return TextFormField(
        decoration: const InputDecoration(
          labelText: 'Phone',
        ),
        controller: _phone);
  }

  Widget get _privacyStatement {
    return FormField<bool>(
      initialValue: _termsChecked,
      builder: (FormFieldState<bool> state) {
        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              "Roma Technology Limited (Romatech) is committed to protecting and respecting your privacy. We will only use your personal information to administer your account and to provide the products and services you have requested from us.\n\nIn order to provide you with the service requested we will need to store and process your personal data. If you consent to us storing your personal data for this purpose please tick the checkbox below.\n\nWe will not use this information for any other purposes and will not provide any of your personal information to any other party without your express consent.\n\nYou may withdraw your consent at anytime by contacting us at ",
                        ),
                        TextSpan(
                          text: "hello@romatech.co.uk",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('mailto:hello@romatech.co.uk');
                            },
                        ),
                        const TextSpan(
                          text: ". For more information please see our ",
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://www.romatech.co.uk/privacy-policy-cookie-restriction-mode');
                            },
                        ),
                      ],
                    ),
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
                  const Text('I agree to Roma Technology Limited storing and processing my personal data.'),
                ],
              ),
              state.errorText == null ? const Text('') : Text(state.errorText!, style: const TextStyle(color: Color(0xFFe53935), fontSize: 12)),
            ],
          ),
        );
      },
      validator: (val) => _validateTerms(_termsChecked),
    );
  }

  Widget get _imageOne {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _images.isEmpty
            ? _imageAndTextRow('form 1')
            : GridView.builder(
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final _image = _images[index];
                  return Image(image: _image);
                },
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              ),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                getPhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera),
            ),
            IconButton(
              onPressed: () {
                getPhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.image),
            ),
          ],
        ),
      ],
    );
  }

  //
  // VALIDATORS
  //

  String? _validateTitle(String? value) {
    if (value!.isEmpty) {
      return 'Must not be empty';
    }
    return null;
  }

  _validateTerms(value) {
    if (!value) {
      return 'Not checked';
    }
    return null;
  }

  //
  // Methods
  //
  void getPhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    setState(() {
      if (kIsWeb) {
        _images.add(image.path);
      } else {
        _images.add(File(image.path));
      }
    });
  }

  Widget _imageAndTextRow(String contentName) {
    return Row(
      children: <Widget>[
        Image.network(_cmsContent[contentName]!.mediaContent, width: 100,),
        Text(_cmsContent[contentName]!.textContent),
      ],
    );
  }
}
