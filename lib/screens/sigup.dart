
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:boxapp/services/firebase_helper.dart';
import 'package:boxapp/services/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../screens/home.dart';

import 'package:flutter/material.dart';

  int snapshotValue(dataSnapshot)  {
  dataSnapshot.value!.forEach((key, value) {
     lengthnoti++;
  });
  return lengthnoti;
  }
  Future getlength(String userpath) async {
 
  final ref = FirebaseDatabase.instance.ref(userpath);
  DataSnapshot dataSnapshot = (await ref.once()).snapshot;
      if(dataSnapshot.value != null){      
          snapshotValue(dataSnapshot);
      }  
  }
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
 
  static Future<User?> loginUsingEmailPassword({required String email,required String password, required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? user;
  try{
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    
  }on FirebaseAuthException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(e.toString()),
        ),
       );
  }
  return user;
}
  bool isLoading = false;

  @override
  void initState() {
  AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
           NotificationService.displayNotificationRationale();
                    }
      });
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    var pathusr = getdbpath();
    getlength(pathusr!);
  }

  @override

  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        title:Row( 
        children:<Widget> [
          Image.asset("images/logo.png", width: 105,height: 45,alignment: Alignment.bottomLeft,),
          const Text("SAFEHAVEN PACKAGES",textAlign: TextAlign.left,),//style: TextStyle(color: Colors.white), 
          
        ]
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Sign in / Sign up using email and password'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'example@email.com',
                    labelText: 'Enter your mail',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '*******',
                    labelText: 'Enter your password',
                  ),
                ),
              ),

             ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 0, 0, 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size(120, 40),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          textStyle: const TextStyle(fontSize: 20)
                        ),
                        onPressed:() async {
                              User? user;
                              user = await loginUsingEmailPassword(email: emailController.text, password: passwordController.text, context: context);
                              if (user != null){ 
                               // Navigator.push(context,MaterialPageRoute(builder: (context) =>  const HomeScreen()));
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
                              }
                          }, 
                        child: const Text( "Sign In"),
                    )
                    ]
                  )
                ),

              const SizedBox(height: 10, ),
              isLoading
                  ? const CircularProgressIndicator()
                  : 
                  ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 0, 0, 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size(120, 40),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          textStyle: const TextStyle(fontSize: 20)
                        ),
                        onPressed:() async {
                            setState(() {
                          isLoading = true;
                        });
                        if (!isValidForm(context)) {
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        try {
                          final isSaved = await FirebaseHelper.saveUser(
                            email: emailController.text,
                            password: passwordController.text,
                           // name: nameController.text,
                          );

                          if (isSaved && mounted) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            // Navigator.push(context,MaterialPageRoute( builder: (context) =>  const HomeScreen(), ), );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }

                        setState(() {
                          isLoading = false;
                        });
                           
                          }, 
                        child: const Text( "Sign Up"),
                    )
                    ]
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidForm(BuildContext context) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty
         //|| nameController.text.isEmpty
        ) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill all fields'),
        ),
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters length'),
        ),
      );
      return false;
    }

    return true;
  }
}