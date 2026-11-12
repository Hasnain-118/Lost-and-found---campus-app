import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final formKey = GlobalKey<FormState>();

  void message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void verify() {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      message('Code entered. Verification is not connected yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5140EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Verify your email'),
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
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFFEFEDFF),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 42,
                      color: purple,
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Check your inbox',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Enter your 6-digit verification code for',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    widget.email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == 5 ? 0 : 8,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) =>
                            value == null || value.isEmpty ? '•' : null,
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      message('Resending is not connected yet.');
                    },
                    child: const Text(
                      'Resend code',
                      style: TextStyle(color: purple),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEDFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'One step closer!\n'
                          'Email verification helps protect your account.',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: verify,
                      style: FilledButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Verify & continue'),
                    ),
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