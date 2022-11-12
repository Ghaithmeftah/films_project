// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import '../login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Sign(),
    );
  }
}

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  //variable for the show-hide password
  bool _isobscure = true;
  //create a key for the Form Widget
  final _formkey = GlobalKey<FormState>();
  //create the texfield controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  var loading = false;
  @override
  Widget build(BuildContext context) {
    String? _requiredValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        return 'this field is required';
      }
      return null;
    }

    void _handleSignUpError(FirebaseAuthException e) {
      String MessageToDisplay;
      switch (e.code) {
        case 'email-already-in-use':
          MessageToDisplay = 'this email is already in use ';
          break;
        case 'invalid-email':
          MessageToDisplay = 'The email you entered is invalid';
          break;
        case 'operation-not-allowed':
          MessageToDisplay = 'This operation is not allowed';
          break;
        case 'weak-password':
          MessageToDisplay = 'The password you entered is too weak';
          break;
        default:
          MessageToDisplay = 'an unknown error occured';
          break;
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Sign up failed'),
                content: Text(MessageToDisplay),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('ok'),
                  )
                ],
              ));
    }

    Future _SignUp() async {
      setState(() {
        loading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance.collection('users').add({
          'email': _emailController.text,
          'password': _passwordController.text,
        });

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Sign up succeeded'),
                  content: const Text(
                      'Your account was created ,you can now log in'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text('ok'))
                  ],
                ));
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        _handleSignUpError(e);
        setState(() {
          loading = false;
        });
      }
    }

    return SizedBox(
        height: 800,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 6,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment(-2, 0),
                      image: AssetImage("images/swim.png"),
                      fit: BoxFit.fill)),
              margin: const EdgeInsets.only(top: 31),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: IconButton(
                color: Colors.black,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0, top: 10),
                            child: Text(
                              "Join our Community ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 108, 113, 113)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 10.0),
                            child: Text(
                              "Create Account",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 21, 23, 24)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            minWidth: 10,
                            height: 80,
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.orange,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Text("G  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                Text(
                                  "Create with Google",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          MaterialButton(
                            minWidth: 10,
                            height: 80,
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.orange,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: Icon(Icons.apple),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Create with Apple",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Center(
                        child: Text(
                          "Or Login using Email",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 7),
                              height: 80,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: _requiredValidator,
                                  controller: _nameController,
                                  enableSuggestions: true,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.person),
                                    suffixIconColor: Colors.orange,
                                    hintText: "Johnson Doe",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 7),
                              height: 80,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: _requiredValidator,
                                  controller: _emailController,
                                  enableSuggestions: true,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.email_outlined),
                                    suffixIconColor: Colors.orange,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 7, bottom: 20, left: 50, right: 50),
                              height: 80,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  validator: _requiredValidator,
                                  controller: _passwordController,
                                  obscureText: _isobscure,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_isobscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isobscure = !_isobscure;
                                        });
                                      },
                                    ),
                                    suffixIconColor: Colors.orange,
                                    hintText: "Password",
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          if (!loading) ...[
                            Container(
                              height: 80,
                              width: 200,
                              margin: const EdgeInsets.only(left: 50),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: MaterialButton(
                                child: Center(
                                    child: Text(
                                  "Continue",
                                  style: GoogleFonts.prociono(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      fontSize: 18.0),
                                )),
                                onPressed: () {
                                  if (_formkey.currentState != null &&
                                      _formkey.currentState!.validate()) {
                                    _SignUp();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                  }
                                },
                              ),
                            ),
                          ],
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 244, 231, 214),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: MaterialButton(
                              child:
                                  const Center(child: Icon(Icons.fingerprint)),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already A Team Member?"),
                          TextButton(
                              child: const Text(
                                "LOG IN",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1.2,
                                  color: Color(0xff0095ff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  )),
                        ],
                      ),
                    ]),
              ),
            )
          ],
        ));
  }
}
