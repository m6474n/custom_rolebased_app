import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:role_based_app/screens/auth/phone_login.dart';
import 'package:role_based_app/screens/auth/register.dart';
import 'package:role_based_app/screens/student.dart';
import 'package:role_based_app/screens/widgets/round_button.dart';
import 'package:role_based_app/utils/utilitiy.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading =false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() { setState(() {
    loading = true;
  });
    _auth.signInWithEmailAndPassword(email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value) {
      Utils().onSuccess(value.user!.email.toString()); setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentScreen()));

    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().onError(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.deepPurple,

                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Login to your account.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_open_outlined),
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      RoundButton(
                        title: 'Login',
                        loading: loading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("don't have any account?",
                              style: TextStyle(
                                  fontSize: 16)),
                          TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const Register()));
                          }, child: const Text('Register',
                              style: TextStyle(
                                fontSize: 16,))
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                   InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>const PhoneLogin()));
                     },
                     child: Container(
                       height: 50,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.deepPurple)
                       ),
                       child: const Center(child: Text('Login with Phone' ,style: TextStyle(color: Colors.deepPurple),)),
                     ),
                   )
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
