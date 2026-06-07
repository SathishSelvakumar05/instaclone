import 'package:alab/Concepts/RefreshToken/ApiService/LoginCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Map<String, dynamic> loginData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Login Screen'),
              background: Container(color: Colors.blue),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  loginData['username'] = email.text.toString();
                  loginData['password'] = password.text.toString();
                  loginData[' expiresInMins'] = 30;
                  await context.read<LoginCubit>().LoginUser(loginData);
                  final name = context.read<LoginCubit>().state.username;
                  Fluttertoast.showToast(msg: "Welcome $name");
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
