// rejestracja.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mhapp/logowanie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Kontrolery do zarządzania wprowadzanym tekstem
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white, // Adjusted to match the MainScreen style
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Consistent background image
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY,
          ),
        ),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Imię',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać imię';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) { // Sprawdzenie, czy wartość zawiera tylko litery
                      return 'Imię może zawierać tylko litery';
                    }
                    return null;
                  },

                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Nazwisko',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać nazwisko';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) { // Sprawdzenie, czy wartość zawiera tylko litery
                      return 'Nazwisko może zawierać tylko litery';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: 'Login',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać poprawny login';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Proszę wpisać poprawny adres e-mail';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Hasło',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Hasło musi mieć co najmniej 6 znaków';
                    }
                    if (_confirmPasswordController.text != value) {
                      return 'Hasła nie pasują do siebie';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Powtórz hasło',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Hasło musi mieć co najmniej 6 znaków';
                    }
                    if (_passwordController.text != value) {
                      return 'Hasła nie pasują do siebie';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Numer telefonu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 9) {
                      return 'Proszę wpisać poprawny numer telefonu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight / 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900], // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _registerUser();
                }
              },
              child: const Text(
                'Zarejestruj się',
                style: TextStyle(color: Colors.white),
                ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _loginController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          // Zapisywanie dodatkowych informacji użytkownika w Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'login': _loginController.text,
            'phoneNumber': _phoneNumberController.text,
            'coins':0,
            'Karnet_1h':0,
            'Karnet_4h':0,
            'Karnet_8h':0,
            'Karnet_Open':0,
            'logger': false,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wysłaliśmy link weryfikacyjny na Twój adres e-mail. Sprawdź swoją skrzynkę odbiorczą i postępuj zgodnie z instrukcjami, aby zweryfikować konto.')),
          );

          // Przekierowanie do ekranu logowania po wysłaniu e-maila weryfikacyjnego i zapisaniu danych
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }

      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Wystąpił błąd podczas rejestracji. Spróbuj ponownie.';
        if (e.code == 'weak-password') {
          errorMessage = 'Podane hasło jest zbyt słabe.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Konto dla tego adresu e-mail już istnieje.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Adres e-mail jest nieprawidłowy.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił nieoczekiwany błąd. Spróbuj ponownie.')),
        );
      }
    }
  }





}

