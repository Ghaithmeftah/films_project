import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Films_API.dart';
import '../WelcomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../signUp.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp1 = await Firebase.initializeApp();
    return firebaseApp1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Log();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  // variable for the show-hide password
  bool _isObscure = true;
  //create a key for the Form widget
  final _formkey = GlobalKey<FormState>();
  //create the texfield controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var loading = false;
  //alert fonction
  Future alert(String? ch) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Log in Failed:",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
        ),
        content: Text(
          "$ch",
          style: GoogleFonts.bitter(
            letterSpacing: .9,
            textStyle: const TextStyle(
                color: Color.fromARGB(255, 207, 154, 93),
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "ok",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //login fonction
  Future<User?> loginUsinEmailPassword(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      var errorCode = e.code;
      var errorMessage = e.message;
      if (e.code == "user-not-found") {
        alert("no user found for that email");
      } else if (errorCode == 'auth/wrong-password') {
        alert('wrong password');
      } else {
        alert(errorMessage);
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    //fonction to validate if the fields are empty or filled
    String? _requiredValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        return 'this field is required';
      }
      return null;
    }

    return SizedBox(
        height: 800,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment(-2, 0),
                      image: AssetImage("images/maxresdefault.png"),
                      fit: BoxFit.fill)),
              margin: const EdgeInsets.only(top: 31),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: IconButton(
                color: Colors.black,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen())),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0, top: 10),
                            child: Text(
                              "WELCOME BACK ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 108, 113, 113)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 10.0),
                            child: Text(
                              "Account Log In ",
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
                        children: <Widget>[
                          MaterialButton(
                            minWidth: 20,
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
                                  "Login with Google",
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
                            minWidth: 20,
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
                                Text(
                                  "  Login with Apple",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
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
                          "Or Create Using Email",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              height: 80,
                              // decoration: BoxDecoration(
                              //   border:
                              //       Border.all(color: Colors.orange, width: 1),
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              child: Center(
                                child: TextFormField(
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  validator: _requiredValidator,
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        const Icon(Icons.email_outlined),
                                    suffixIconColor: Colors.orange,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          style: BorderStyle.solid,
                                          color: Colors.orange,
                                          width: 1,
                                        )),
                                    // border: OutlineInputBorder(
                                    //   borderSide: BorderSide.none,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 50, right: 50, bottom: 20),
                              height: 80,
                              //create an orange border
                              // decoration: BoxDecoration(
                              //   border:
                              //       Border.all(color: Colors.orange, width: 1),
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: passwordController,
                                validator: _requiredValidator,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  hoverColor: Colors.orange,
                                  suffixIconColor: Colors.orange,
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                  hintText: "Password",
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 1,
                                        color: Colors.orange),
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
                              onPressed: () async {
                                if (_formkey.currentState != null &&
                                    _formkey.currentState!.validate()) {
                                  User? user = await loginUsinEmailPassword(
                                      emailController.text,
                                      passwordController.text,
                                      context);
                                  if (user != null) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FilmsAPI(),
                                        ));
                                  }
                                }
                              },
                            ),
                          ),
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
                          const Text("Don't Have An Acount?"),
                          TextButton(
                              child: const Text(
                                "REGISTER",
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
                                            const SignUpPage()),
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

// Container(
//   margin: const EdgeInsets.symmetric(
//       horizontal: 50.0, vertical: 5.0),
//   height: 80,
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(
//       width: 1,
//       color:
//           const Color.fromARGB(255, 250, 168, 27),
//     ),
//     borderRadius: BorderRadius.circular(10.0),
//   ),
//   child: Row(
//     children: [
//       SizedBox(
//         height: 60,
//         child: TextField(
//           decoration: InputDecoration(
//             labelText: "Email",
//             border: OutlineInputBorder(
//                 borderSide: BorderSide.none,
//                 borderRadius:
//                     BorderRadius.circular(10.0)),
//           ),
//         ),
//       ),
//       Icon(Icons.email)
//     ],
//   ),
// )
