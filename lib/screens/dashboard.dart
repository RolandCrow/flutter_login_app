

import 'package:flutter/material.dart';
import 'package:flutter_login_app/providers/user_provider.dart';
import 'package:flutter_login_app/utility/shared_preference.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../domain/user.dart';

class DashBoard extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _DashBoardState();
  
}


class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD PAGE'),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(child: Text('${user.email}')),
          const SizedBox(height: 100,),
          TextButton(
              onPressed: () {
                UserPreference().removeUser();
                Navigator.pushReplacementNamed(context, '/login');
              },
            child: const Text('Logout'),
            style: TextButton.styleFrom(primary: Colors.lightBlueAccent),
          )
        ],
      ),
    );
    
    
    
  }
  
  
}