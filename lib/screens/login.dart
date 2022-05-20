

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/providers/auth_provider.dart';
import 'package:flutter_login_app/providers/user_provider.dart';
import 'package:flutter_login_app/utility/shared_preference.dart';
import 'package:flutter_login_app/utility/validator.dart';
import 'package:flutter_login_app/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../domain/user.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {





  final formKey = GlobalKey<FormState>();
  late String _userName, _password;



  @override
  Widget build(BuildContext context) {

    Future<User> getUserData() => UserPreference().getUser();

    AuthProvider auth = Provider.of<AuthProvider>(context);
    doLogin() {
      final form = formKey.currentState;
      if(form!.validate()) {
        form.save();

        final Future<Map<String, dynamic>> response = auth.login(_userName, _password);

        response.then((response) {
          if(response['status']) {
            User user = response['user'];

            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Fluttertoast.showToast(
                msg: "Failed login",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        });


      } else {
        Fluttertoast.showToast(
            msg: "Invalid form. Please complte the form properly",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }

    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          child: const Text("Forgot password?",
              style:  TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        TextButton(
          child: const Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );




      return Scaffold(
        appBar: AppBar(title: const Text('Login'),),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const SizedBox(height: 15.0,),
                  const Text("Email"),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    validator: validateEmail,
                    onSaved: (value) => _userName = value! ,
                    decoration: buildInputDecoration("Enter Email", Icons.email),

                  ),
                  const SizedBox(height: 20.0,),
                  const Text('Password'),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value) => value!.isEmpty? "Please enter password": null,
                    decoration: buildInputDecoration("Enter Password", Icons.lock),
                  ),
                  const SizedBox(height: 20.0,),
                  auth.loggedInStatus == Status.authenticating
                  ? loading: longButtons('Login', doLogin),
                  const SizedBox(height: 8.0,),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      );
  }
}