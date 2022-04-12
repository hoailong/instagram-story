import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leaningflutter/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String? email, String? password) async {
    try {
      final response = await http.post(
          Uri.parse('https://reqres.in/api/register'),
          body: {'email': email.toString(), 'password': password.toString()});
      if (response.statusCode == 200) {
        print('SUCCESS');
      } else {
        print('FAIL');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Account'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              cursorColor: primaryColor,
              controller: emailController,
              decoration:
                  InputDecoration(hintText: 'Email', fillColor: primaryColor),
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              cursorColor: primaryColor,
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Password', fillColor: primaryColor),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                login(emailController.text.toString(),
                    passwordController.text.toString());
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
