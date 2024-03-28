import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userId;

  const AccountSettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      _firstNameController.text = userData['firstName'] ?? '';
      _lastNameController.text = userData['lastName'] ?? '';
      _phoneNumberController.text = userData['phoneNumber'] ?? '';

      setState(() => _isLoading = false);
    } catch (e) {
      print('Błąd przy ładowaniu danych użytkownika: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia Konta'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Imię może zawierać tylko litery';
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
                  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Nazwisko może zawierać tylko litery';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Numer telefonu'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać numer telefonu';
                  } else if (value.length != 9 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Numer telefonu musi składać się z 9 cyfr';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'Nowe Hasło'),
                obscureText: true, // Ukrywa wprowadzane hasło
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać nowe hasło';
                  } else if (value.length < 6) {
                    return 'Hasło musi mieć co najmniej 6 znaków';
                  } else if (_newPasswordController2.text != value) {
                    return 'Hasła nie pasują do siebie';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController2,
                decoration: const InputDecoration(labelText: 'Powtórz Hasło'),
                obscureText: true, // Ukrywa wprowadzane hasło
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserSettings,
                child: const Text('Zaktualizuj Dane'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUserSettings() async {
    Map<String, dynamic> updates = {};

    // Walidacja i aktualizacja imienia, jeśli zostało zmienione
    if (_firstNameController.text.isNotEmpty) {
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(_firstNameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imię może zawierać tylko litery')));
        return; // Przerwanie funkcji, jeśli walidacja się nie powiedzie
      } else {
        updates['firstName'] = _firstNameController.text;
      }
    }

    // Walidacja i aktualizacja nazwiska, jeśli zostało zmienione
    if (_lastNameController.text.isNotEmpty) {
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(_lastNameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nazwisko może zawierać tylko litery')));
        return;
      } else {
        updates['lastName'] = _lastNameController.text;
      }
    }

    // Walidacja i aktualizacja numeru telefonu, jeśli został zmieniony
    if (_phoneNumberController.text.isNotEmpty) {
      if (_phoneNumberController.text.length != 9 || !RegExp(r'^[0-9]+$').hasMatch(_phoneNumberController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Numer telefonu musi składać się z 9 cyfr')));
        return;
      } else {
        updates['phoneNumber'] = _phoneNumberController.text;
      }
    }

    // Aktualizacja danych użytkownika w Firestore, jeśli jest coś do zaktualizowania
    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update(updates).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dane zaktualizowane pomyślnie')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wystąpił błąd przy aktualizacji danych')));
      });
    }

    // Aktualizacja hasła, jeśli pola haseł są wypełnione i hasła są takie same
    if (_newPasswordController.text.isNotEmpty && _newPasswordController2.text == _newPasswordController.text) {
      if (_newPasswordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hasło musi mieć co najmniej 6 znaków')));
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(_newPasswordController.text).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hasło zaktualizowane pomyślnie')));
      }).catchError((error) {
        print('Wystąpił błąd przy aktualizacji hasła: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wystąpił błąd przy aktualizacji hasła. Może być konieczne ponowne zalogowanie się.')));
      });
    } else if (_newPasswordController.text.isNotEmpty || _newPasswordController2.text.isNotEmpty) {
      // Jeśli jedno z pól haseł jest wypełnione, ale hasła nie są takie same lub drugie pole jest puste
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hasła nie pasują do siebie')));
    }
  }




  @override
  void dispose() {
    // Pamiętaj o zwolnieniu kontrolerów, aby uniknąć wycieków pamięci
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
