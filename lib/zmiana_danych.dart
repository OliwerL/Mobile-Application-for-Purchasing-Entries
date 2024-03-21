import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userId; // Identyfikator użytkownika do pobrania danych

  const AccountSettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true; // Flag, aby wskazać ładowanie danych

  // Kontrolery do zarządzania wprowadzanym tekstem
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      _firstNameController.text = userData['imie'] ?? '';
      _lastNameController.text = userData['nazwisko'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _phoneNumberController.text = userData['numer_telefonu'] ?? '';

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Obsługa błędów, np. pokazanie komunikatu
      print('Błąd przy ładowaniu danych użytkownika: $e');
      setState(() {
        _isLoading = false;
      });
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
              // Pola formularza z wstępnie wypełnionymi danymi
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Imię'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nazwisko'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Numer telefonu'),
                keyboardType: TextInputType.phone,
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

  void _updateUserSettings() {
    // Logika aktualizacji wybranych danych użytkownika
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'imie': _firstNameController.text,
      'nazwisko': _lastNameController.text,
      'email': _emailController.text,
      'numer_telefonu': _phoneNumberController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dane zaktualizowane pomyślnie')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd przy aktualizacji danych')),
      );
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
