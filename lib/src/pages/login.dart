import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  Widget msgReset = LinearProgressIndicator();
  bool passReseted = false;

  // final FirebaseAuth = _auth = FirebaseAuth.instance;
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/logo1.png",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);

                    if (value.isEmpty) {
                      return "Ingrese un email";
                    } else if (!emailValid) {
                      return "Enter Valid Email";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ingrese una contraseña";
                    } else if (passController.text.length < 6) {
                      return "La contraseña Debe tener más de 6 caracteres";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: () {
                    if (_formfield.currentState!.validate()) {
                      debugPrint("datos login agregado correctamente");
                      signIn();
                      // Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿Has olvidado tu contraseña?",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _showDialog();
                          enviarLinkdeRestablecer();
                        },
                        child: const Text(
                          "recuperar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
      emailController.clear();
      passController.clear();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      passController.clear();
      SnackBar snack_1 = const SnackBar(
        content: Text(
          "Email o contraseña incorrecta :(",
          style: TextStyle(color: Colors.red),
        ),
        duration: Duration(seconds: 8),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack_1);
    }
  }

  Future<void> _showDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: msgReset,
            // content: msgReset,
            actions: <Widget>[
              TextButton(
                onPressed: passReseted
                    ? () {
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Center(child: Text("ACEPTAR")),
              ),
            ],
          );
        });
  }

  Future enviarLinkdeRestablecer() async {
    // if (emailController.text == "") {
    //   setState(() {
    //     passReseted = true;
    //     msgReset = const Text("Debe ingresar primero su correo");
    //   });
    //   return null;
    // }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      setState(() {
        passReseted = true;
        msgReset = const Text(
            "Se le envío un email a su cuenta para restablecer su contraseña");
      });
      return null;
    } on FirebaseAuthException catch (e) {
      setState(() {
        passReseted = true;
        msgReset = const Text(
            "Coreo no registrado o inválido, verifique si escribió bien");
      });
    }
  }
}
