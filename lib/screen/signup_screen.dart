import 'dart:io';

import 'package:flutter/material.dart';

import '../data/firebase_service/firebase_auth.dart';
import '../util/dialog.dart';
import '../util/exception.dart';
import '../util/image_picker.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode emailF = FocusNode();
  final password = TextEditingController();
  FocusNode passwordF = FocusNode();
  final passwordConfirm = TextEditingController();
  FocusNode passwordConfirmF = FocusNode();
  final username = TextEditingController();
  FocusNode usernameF = FocusNode();
  final bio = TextEditingController();
  FocusNode bioF = FocusNode();
  File? _imageFile;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    username.dispose();
    bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(width: 96, height: 10),
              Center(
                child: Image.asset('images/logo.jpg'),
              ),
              const SizedBox(width: 96, height: 70),
              InkWell(
                onTap: () async {
                  File imagefilee = await ImagePickerr().uploadImage('gallery');
                  setState(() {
                    _imageFile = imagefilee;
                  });
                },
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 34,
                          backgroundImage:
                              const AssetImage('images/person.png'),
                          backgroundColor: Colors.grey.shade200,
                        )
                      : CircleAvatar(
                          radius: 34,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          backgroundColor: Colors.grey.shade200,
                        ),
                ),
              ),
              const SizedBox(height: 40),
              textfield(email, emailF, 'Email', Icons.email),
              const SizedBox(height: 15),
              textfield(username, usernameF, 'username', Icons.person),
              const SizedBox(height: 15),
              textfield(bio, bioF, 'bio', Icons.abc),
              const SizedBox(height: 15),
              textfield(password, passwordF, 'Password', Icons.lock),
              const SizedBox(height: 15),
              textfield(passwordConfirm, passwordConfirmF, 'PasswordConfirme',
                  Icons.lock),
              const SizedBox(height: 15),
              signup(),
              const SizedBox(height: 15),
              have()
            ],
          ),
        ),
      ),
    );
  }

  Widget have() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Don you have account?  ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              "Login ",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget signup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().signUp(
              email: email.text,
              password: password.text,
              passwordConfirme: passwordConfirm.text,
              username: username.text,
              bio: bio.text,
              profile: _imageFile ?? File(''),
            );
          } on Exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding textfield(TextEditingController controll, FocusNode focusNode,
      String typename, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 18, color: Colors.black),
          controller: controll,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: typename,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
