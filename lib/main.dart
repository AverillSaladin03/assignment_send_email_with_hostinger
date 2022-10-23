import 'dart:convert';

import 'package:assignment_send_email_with_hostinger/services/services.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ctrlEmail = TextEditingController();
  @override
  void dispose() {
    ctrlEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Form(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: ctrlEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return EmailValidator.validate(value.toString())
                  ? null
                  : "Email Invalid";
            },
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await SendMailTrain.sendMail(ctrlEmail.text.toString()).then((value) {
            var result = json.decode(value.body);
            Fluttertoast.showToast(
                msg: result['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor:
                    result['code'] == 200 ? Colors.green : Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        },
        tooltip: 'Send mail',
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}
