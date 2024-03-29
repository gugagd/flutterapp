import 'package:flutter/material.dart';
import 'package:meuapp/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset("logotipo_firma.png"),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: null,
                maxLength: 30,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    hintText: 'Insira seu email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: showPassword,
                controller: null,
                maxLength: 30,
                decoration: InputDecoration(
                    suffixIcon: Container(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword == false
                            ? Icon(Icons.visibility,
                                color: Colors.white, size: 18)
                            : Icon(Icons.visibility_off,
                                color: Colors.white, size: 18),
                      ),
                    ),
                    filled: true,
                    hintText: 'Insira a senha',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute( 
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                  child: Text("Entrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
