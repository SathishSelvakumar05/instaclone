import 'package:alab/LocalStorage/CRUD/User_CRUD.dart';
import 'package:alab/Presentation/Screens/HomeScreen.dart';
import 'package:alab/Presentation/Screens/LoginScreen.dart';
import 'package:alab/main.dart';
import 'package:flutter/material.dart';
class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({super.key});

  @override
  State<AutoLoginScreen> createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLoginScreen> {
  void initState() {
    super.initState();
    AutoLogin();
  }
  AutoLogin()async{
    final user = await User().getUser(localDB);
    if(user!=null&&user.isNotEmpty){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>DashboardScreen()),(Route<dynamic> route) => false,);
    }
    else{
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Loginscreen()),(Route<dynamic> route) => false,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("assets/Images/alab.jpg"),);
  }
}
