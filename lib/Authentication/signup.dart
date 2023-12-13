import 'package:flutter/material.dart';
import 'package:sqlite_desktop_authentication/Authentication/components/background.dart';
import 'package:sqlite_desktop_authentication/Authentication/login.dart';
import 'package:sqlite_desktop_authentication/Components/button.dart';
import 'package:sqlite_desktop_authentication/Components/textfield.dart';
import 'package:sqlite_desktop_authentication/SQLite/database_helper.dart';
import 'package:sqlite_desktop_authentication/SQLite/json.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usrName = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isValidated = false;

  final formKey = GlobalKey<FormState>();
  final DatabaseHelper db = DatabaseHelper();
  register()async{
    var res = await db.createUser(Users(fullName: fullName.text, email: email.text, usrName: usrName.text, password: password.text));
    if(res > 0){
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Background(
      height: .75,
        image: "signup.gif",
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
      title: Text("REGISTER"),
      subtitle: Text("SIGN UP, To access vital information"),
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
                      return "Full name is required";
                    }
                    return null;
                  },
                  hintText: "Full name",
                  icon: Icons.person,
                  controller: fullName),

              InputField(
                  validator: (value){
                    if(value.isEmpty){
                      return "Email is required";
                    }
                    return null;
                  },
                  hintText: "Email",
                  icon: Icons.email,
                  controller: email),


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

              InputField(
                  trailing: const Icon(Icons.visibility_off),
                  validator: (value){
                    if(value.isEmpty){
                      return "Re-enter password is required";
                    }else if(password.text != confirmPassword.text){
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  hintText: "Re-enter password", icon: Icons.lock, controller: confirmPassword),

              //Button
              Button(label: "REGISTER", press: () {
                if(formKey.currentState!.validate()){

                  register();
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
                  const Text("Already have an account"),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));
                  }, child: const Text("LOGIN")),
                ],
              ),
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
