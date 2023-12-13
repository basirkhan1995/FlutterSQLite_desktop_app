
import 'package:flutter/material.dart';
import 'package:sqlite_desktop_authentication/Authentication/components/background.dart';
import 'package:sqlite_desktop_authentication/Authentication/signup.dart';
import 'package:sqlite_desktop_authentication/Components/button.dart';
import 'package:sqlite_desktop_authentication/Components/textfield.dart';
import 'package:sqlite_desktop_authentication/SQLite/database_helper.dart';
import 'package:sqlite_desktop_authentication/SQLite/json.dart';
import 'package:sqlite_desktop_authentication/Views/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usrName = TextEditingController();
  final password = TextEditingController();
  bool isValidated = false;
  bool isLoginTrue = false;
  final formKey = GlobalKey<FormState>();
  final DatabaseHelper db = DatabaseHelper();

  login()async{
    var res = await db.authenticate(Users(usrName: usrName.text, password: password.text));
    if(res == true){
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
    }else{
      setState(() {
        isLoginTrue = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Background(
        image: "login.gif",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [header(), body(), messages()],
            ),
          ),
        ));
  }

  //Header
  Widget header() {
    return const ListTile(
      title: Text("Welcome"),
      subtitle: Text("Enter your credentials to access your vital"),
    );
  }

  Widget body() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputField(
                validator: (value){
                  if(value.isEmpty){
                    return "Username is required";
                  }
                  return null;
                },
                  hintText: "Username",
                  icon: Icons.account_circle_rounded,
                  controller: usrName),
              InputField(
                  trailing: const Icon(Icons.visibility_off),
                validator: (value){
                  if(value.isEmpty){
                    return "Password is required";
                  }
                  return null;
                },
                  hintText: "Password", icon: Icons.lock, controller: password),

              //Button
              Button(label: "LOGIN", press: () {
                if(formKey.currentState!.validate()){

                  login();
                  //otherwise disable the message
                  setState(() {
                    isValidated = false;
                  });
                }else{
                  //if text fields are empty show the message
                  setState(() {
                    isValidated = true;
                  });
                }
              }),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUp()));
                      },
                      child: const Text("REGISTER")),
                ],
              ),

              TextButton(
                  onPressed: () {

                  }, child: const Text("Forgot password?")),
            ],
          ),
        ),
      ),
    );
  }

  Widget messages() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          isLoginTrue
              ? Text(
                  "Access Denied, Username or Password is incorrect",
                  style: TextStyle(color: Colors.red.shade900),
                )
              : const SizedBox(),
          isValidated
              ? Text(
                  "Form is not validated, check above",
                  style: TextStyle(color: Colors.red.shade900),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
