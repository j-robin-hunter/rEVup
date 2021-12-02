import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/services/cloud_firestore_service.dart';

class LeadForm extends StatefulWidget {
  const LeadForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LeadFormState();
  }
}

class LeadFormState extends State<LeadForm>{
  final _leadFormKey = GlobalKey<FormState>();

  String _name = '';

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final cloudFirestoreService = Provider.of<CloudFirestoreService>(context);

    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _leadFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildName(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if(!_leadFormKey.currentState!.validate()) {
                  return;
                }
                _leadFormKey.currentState!.save();
                cloudFirestoreService.getLeadsCollection().add({'name': _name, 'owner': 'robin'})
                    .then((value) => print('added'));
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}