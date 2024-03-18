import 'package:flutter/material.dart';
import 'package:recipe_app/navigation_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'home.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Vault Application', // <-- You could set the app name here
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> checkUserData() async {
    final username = _preferences.getString('username');
    final password = _preferences.getString('password');
    if (username == _usernameController.text &&
        password == _passwordController.text) {
      // Credentials match, proceed with login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavigationView()),
      );
    } else {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Vault'), // <-- You could add the logo here
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 67,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      checkUserData();
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to register page.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpApp()),
                    );
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
