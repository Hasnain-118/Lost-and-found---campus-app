import 'package:flutter/material.dart';
import 'verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  bool hidePassword = true;
  bool accepted = false;

  InputDecoration style(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Reusable field for name, ID, and phone.
  Widget field(String label, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: style(label),
        validator: (value) {
          if (!optional && (value == null || value.trim().isEmpty)) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  void signup() {
    if (!formKey.currentState!.validate()) return;

    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyEmailScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Join your campus'),
        backgroundColor: const Color(0xFFF8F9FD),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 390,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'A community that looks out for each other.',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),

                  field('Full name'),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: style('University email'),
                    onChanged: (value) => email = value.trim(),
                    validator: (value) {
                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value?.trim() ?? '')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  field('Student / employee ID'),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: style('Department'),
                    items: [
                      'Software Engineering',
                      'Computer Science',
                      'Electrical Engineering',
                      'Mechanical Engineering',
                      'Business Administration',
                      'Other',
                    ].map((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (_) {},
                    validator: (value) =>
                    value == null ? 'Select a department' : null,
                  ),
                  const SizedBox(height: 16),

                  field('Phone number (optional)', optional: true),

                  TextFormField(
                    obscureText: hidePassword,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: style('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      final password = value ?? '';
                      if (password.length < 8) {
                        return 'Use at least 8 characters';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(password)) {
                        return 'Include a number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: purple,
                    title: const Text(
                      'I accept the Terms and Privacy Policy',
                      style: TextStyle(fontSize: 13),
                    ),
                    value: accepted,
                    onChanged: (value) {
                      setState(() => accepted = value ?? false);
                    },
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: signup,
                      style: FilledButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create account'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}