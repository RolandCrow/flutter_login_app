
import 'package:flutter/material.dart';
import 'package:flutter_login_app/domain/user.dart';
import 'package:flutter_login_app/providers/auth_provider.dart';
import 'package:flutter_login_app/providers/user_provider.dart';
import 'package:flutter_login_app/utility/validator.dart';
import 'package:flutter_login_app/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey = GlobalKey<FormState>();
  late String _userName, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of<AuthProvider>(context);

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  const <Widget>[
         CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );


    doRegister() {

      final form = formKey.currentState;
      if(form!.validate()) {
        form.save();
        
        if(_password.endsWith(_confirmPassword)) {
          auth.register(_userName, _password).then((response) {
            if ((response as dynamic)['status']) {
              User user = (response as dynamic)['data'];
              Provider.of<UserProvider>(context).setUser(user);
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
        } else {

          Fluttertoast.showToast(
              msg: "Registration failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }

      } else {
        Fluttertoast.showToast(
            msg: "Mismatch password.'Please enter valid confirm password',",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
    }
      return Scaffold(
        appBar: AppBar(title: const Text('Registration'),),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const SizedBox(height: 15.0,),
                    const Text('Email'),
                    TextFormField(
                      autofocus: false,
                      validator: validateEmail,
                      onSaved: (value) => _userName = value!,
                      decoration: buildInputDecoration('Enter Email', Icons.email),
                    ),
                    const SizedBox(height: 20.0,),
                    const Text('Password'),
                    const SizedBox(height: 5.0,),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      validator: (value)=> value!.isEmpty? 'Please enter password': null,
                      onSaved: (value) => _password = value!,
                      decoration: buildInputDecoration('Enter Password', Icons.lock),
                    ),
                    const SizedBox(height: 20.0,),
                    const Text('Confirm Password'),
                    const SizedBox(height: 5.0,),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      validator: (value)=> value!.isEmpty? 'Your password is required': null,
                      onSaved: (value) => _confirmPassword = value!,
                      decoration: buildInputDecoration('Enter Confirm Password', Icons.lock),
                    ),
                    const SizedBox(height: 20.0,),
                    auth.loggedInStatus == Status.authenticating ?
                        loading :  longButtons('Register', doRegister),
                  ],
                ),
              ),
          ),
        ),
      );
  }




}