/*import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  // Required for form validations
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Handles text onchange
  final TextEditingController nameController;
  final TextEditingController ageController;

  // ignore: use_key_in_widget_constructors
  AppForm({required this.formKey,required this.nameController,required this.ageController});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  String _validateName(String value) {
    if (value.length < 3) return 'Name must be more than 2 charater';
    return ("Thanks but you should Correct what u have written down here");
  }

  String _validateAge(String value) {
    Pattern pattern = r'(?<=\s|^)\d+(?=\s|$)';
    // ignore: non_constant_identifier_names
    RegExp regex = final RegExp(pattern);
    if (!regex.hasMatch(value)) return 'Age must be a number';
    return ("Thanks but you should Correct what u have written down here");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Name'),
            validator: _validateName,
          ),
          TextFormField(
            controller: widget.ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Age'),
            validator: _validateAge,
          ),
        ],
      ),
    );;
  }
}*/