// rejestracja.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'logowanie.dart';
import 'main.dart';

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
    final firestore = FirebaseFirestore.instance;

    // Sprawdzenie, czy login już istnieje
    final QuerySnapshot loginSnapshot = await firestore.collection('guests')
        .where('login', isEqualTo: _loginController.text)
        .get();

    final QuerySnapshot emailSnapshot = await firestore.collection('guests')
        .where('email', isEqualTo: _emailController.text)
        .get();

    // Jeśli znaleziono dokumenty, oznacza to, że login już istnieje
    if (loginSnapshot.docs.isNotEmpty) {

      print('Login "${_loginController.text}" już istnieje w bazie danych.');
      // Tutaj możesz wyświetlić komunikat o błędzie na interfejsie użytkownika
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login jest już zajęty')),
      );

      return;
    }

    if (emailSnapshot.docs.isNotEmpty) {

      print('Login "${_emailController.text}" już istnieje w bazie danych.');
      // Tutaj możesz wyświetlić komunikat o błędzie na interfejsie użytkownika
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email jest już zajęty')),
      );

      return;
    }

    // Jeśli login nie istnieje, kontynuujemy rejestrację
    int guestNumber = 1; // Startujemy od numeru 1

    // Sprawdzenie istniejących elementów
    QuerySnapshot snapshot = await firestore.collection('guests').get();
    final List<DocumentSnapshot> documents = snapshot.docs;

    // Szukamy najwyższego numeru gościa
    for (var document in documents) {
      String guestId = document.id; // 'gosc1', 'gosc2' itd.
      int currentNumber = int.parse(guestId.replaceAll('gosc', '')); // Konwersja 'goscX' do X
      if (currentNumber >= guestNumber) {
        guestNumber = currentNumber + 1; // Ustawiamy numer na następny wolny
      }
    }

    String newGuestId = 'gosc$guestNumber'; // Tworzymy ID dla nowego gościa

    // Dodanie nowego elementu
    firestore.collection('guests').doc(newGuestId).set({
      'imie': _firstNameController.text,
      'nazwisko': _lastNameController.text,
      'login': _loginController.text,
      'email': _emailController.text,
      'haslo': _passwordController.text,  // Pamiętaj o zabezpieczeniach dla haseł!
      'numer_telefonu': _phoneNumberController.text,
    }).then((_) {
      print('Nowy gość $newGuestId zarejestrowany pomyślnie');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      // Tutaj możesz dodać kod do obsługi pomyślnie zarejestrowanego użytkownika (np. wyświetlenie komunikatu, nawigację itp.)
    }).catchError((error) {
      print('Błąd przy rejestracji gościa: $error');
      // Tutaj możesz dodać kod do obsługi błędów (np. wyświetlenie komunikatu o błędzie)
    });
  }

}

