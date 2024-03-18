import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() {
  runApp(const SignUpApp());
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign up',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptPolicy = false;

  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUserData() async {
    await _preferences.setString('username', _usernameController.text);
    await _preferences.setString('password', _passwordController.text);
  }

  Future<void> checkUserData() async {
    final username = _preferences.getString('username');
    final password = _preferences.getString('password');
    if (username != null && password != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Vault'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text(
                  "By signing up your accepted tarm of policy",
                  style: TextStyle(fontSize: 12),
                ),
                value: _acceptPolicy,
                onChanged: (newValue) {
                  setState(() {
                    _acceptPolicy = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _acceptPolicy) {
                    await saveUserData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginApp()),
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Or'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mail),
                    onPressed: () {
                      // SignUp with Gmail
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook),
                    onPressed: () {
                      // SignUp with Facebook
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.tiktok),
                    onPressed: () {
                      // SignUp with Twitter
                    },
                  ),
                ],
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
