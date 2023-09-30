import 'package:flutter/material.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/screen_buttons.dart';

class AddRecordScreen extends StatelessWidget {
  AddRecordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _salaryFormKey = GlobalKey<FormState>();
  final salaryController = TextEditingController();
  String _name = '';
  String _email = '';
  bool? isVisible = false;

  // Form submission function
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process form data here, e.g., send it to a server
      print('Name: $_name');
      print('Email: $_email');
    }
  }

  void _submitSalaryForm() {
    if (_salaryFormKey.currentState!.validate()) {
      _salaryFormKey.currentState!.save();
      salaryController.clear();
      isVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Record'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              addReceivedSalary(),
            ],
          ),
        ));
  }

  Widget addReceivedSalary() {
    return Form(
        key: _salaryFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: salaryController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Enter month salary',
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your received salary';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          print("salary $value");
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ClipOval(
                        child: Material(
                          color: Colors.blue, // Button color
                          child: InkWell(
                            splashColor: Colors.red, // Splash color
                            onTap: () {
                              print("salary inputed ${salaryController.text}");
                              _submitSalaryForm();
                            },
                            child: SizedBox(
                                width: 60,
                                height: 56,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget addRecordForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // You can add more email validation logic here
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              Center(
                  child: ScreenButtons(
                      btnLabel: "Add Record", onTap: _submitForm)),
            ],
          ),
        ));
  }
}
