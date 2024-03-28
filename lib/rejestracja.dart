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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Imię'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać imię';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nazwisko'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać nazwisko';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać poprawny login';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Proszę wpisać poprawny adres e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Hasło'),
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
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Powtórz hasło'),
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
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Numer telefonu'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 9) {
                    return 'Proszę wpisać poprawny numer telefonu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();

                    // Tutaj możesz dodać logikę rejestracji (np. wysłanie danych do API)
                  }
                },
                child: const Text('Zarejestruj się'),
              ),
            ],
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wysłaliśmy link weryfikacyjny na Twój adres e-mail. Sprawdź swoją skrzynkę odbiorczą i postępuj zgodnie z instrukcjami, aby zweryfikować konto.')),
          );

          // Przekierowanie do ekranu logowania po wysłaniu e-maila weryfikacyjnego
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

